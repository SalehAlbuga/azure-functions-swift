//
//  WorkerChannel.swift
//  SwiftFunc
//
//  Created by Saleh on 9/6/19.
//

import Foundation
import GRPC
import NIO
import Dispatch


internal final class WorkerChannel: WorkerChannelProtocol {

    var clientService: AzureFunctionsRpcMessages_FunctionRpcClient!
    
    var workerId: String?
    var requestId: String?
    var messageLength: Int32?
    
    var registry: FunctionRegistry!
    
    var eventStream: BidirectionalStreamingCall<AzureFunctionsRpcMessages_StreamingMessage, AzureFunctionsRpcMessages_StreamingMessage>!
    
    var bindings: [String: [String: AzureFunctionsRpcMessages_BindingInfo]] = [:]
    
    init(workerId: String, requestId: String, messageLength: Int32, registry: FunctionRegistry) {
        self.requestId = requestId
        self.workerId = workerId
        self.messageLength = messageLength
        self.registry = registry
    }
    
    
    public func runClient(host: String, port: Int) {
        
        Logger.log("WorkerChannel Starting")
        
        let clientEventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let configuration = ClientConnection.Configuration(
            target: .hostAndPort(host, port),
            eventLoopGroup: clientEventLoopGroup
        )
        
        let connection = ClientConnection(configuration: configuration)
        
        self.clientService = AzureFunctionsRpcMessages_FunctionRpcClient(channel: connection)
        
        eventStream = clientService.eventStream(handler: streamHandler(message:))
        
        startStream(requestId: requestId!, msg: AzureFunctionsRpcMessages_StartStream())
        
        dispatchMain()
    }
    
}

// Channel
extension WorkerChannel {
    
    func streamHandler(message: AzureFunctionsRpcMessages_StreamingMessage) {
        
        let reqID = message.requestID
        switch message.content {
        case let .some(.workerInitRequest(workerInitRequest)):
            self.workerInitRequest(requestId: reqID, msg: workerInitRequest)
            break
        case let .some(.functionLoadRequest(functionLoadRequest)):
            self.functionLoadRequest(requestId: reqID, msg: functionLoadRequest)
            break
        case let .some(.invocationRequest(invocationRequest)):
            do {
                try self.invocationRequest(requestId: reqID, msg: invocationRequest)
            } catch {
                Logger.log("Fatal Error: \(error.localizedDescription)")
                var res = AzureFunctionsRpcMessages_InvocationResponse()
                res.result = failureStatusResult(result: error.localizedDescription, exceptionMessage: error.localizedDescription, source: "Worker")
                sendMessage(content: .invocationResponse(res), requestId: reqID)
                exit(1)
            }
            break
        case let .some(.functionEnvironmentReloadRequest(envReloadRequest)):
            self.functionEnvironmentReloadRequest(requestId: reqID, msg: envReloadRequest)
        case .none:
            break
        default:
            break
        }
        
    }
    
    func startStream(requestId: String, msg: AzureFunctionsRpcMessages_StartStream) {
        var ststr: AzureFunctionsRpcMessages_StartStream = AzureFunctionsRpcMessages_StartStream()
        ststr.workerID = workerId!
        
        sendMessage(content: .startStream(ststr), requestId: requestId)
    }
    
    func workerInitRequest(requestId: String, msg: AzureFunctionsRpcMessages_WorkerInitRequest) {
        
        var res = AzureFunctionsRpcMessages_WorkerInitResponse()
        res.workerVersion = "0.1.1"
        res.capabilities = ["TypedDataCollection": "TypedDataCollection"] //["RpcHttpBodyOnly": "true"
        res.result = successStatusResult(nil)
        
        sendMessage(content: .workerInitResponse(res), requestId: requestId)
    
    }
    
    func workerHeartbeat(requestId: String, msg: AzureFunctionsRpcMessages_WorkerHeartbeat) {
        // Not Implemented
    }
    
    func workerTerminate(requestId: String, msg: AzureFunctionsRpcMessages_WorkerTerminate) {
        // Not Implemented
    }
    
    func workerStatusRequest(requestId: String, msg: AzureFunctionsRpcMessages_WorkerStatusRequest) {
        // Not Implemented
    }
    
    func fileChangeEventRequest(requestId: String, msg: AzureFunctionsRpcMessages_FileChangeEventRequest) {
        // Not Implemented
    }
    
    func functionLoadRequest(requestId: String, msg: AzureFunctionsRpcMessages_FunctionLoadRequest) {
        
        var res = AzureFunctionsRpcMessages_FunctionLoadResponse()
        res.functionID = msg.functionID
        
        if let _ = self.registry.byName(name: msg.metadata.name) {
            registry.register(id: msg.functionID, forName: msg.metadata.name)
            //            self.functions.removeValue(forKey: msg.metadata.name)
            let info = FunctionInfo(withBindings: msg.metadata.bindings)
            registry.registerInfo(id: msg.functionID, info: info)
            registry.byId(id: msg.functionID)?.convertInputsToDictionary()
            res.result = successStatusResult(nil)
        } else {
            res.result = failureStatusResult(result: "Cannot load \(msg.metadata.name): not found", exceptionMessage: nil, source: nil)
            Logger.log("Cannot load \(msg.metadata.name): not found")
        }
        
        sendMessage(content: .functionLoadResponse(res), requestId: requestId)
        
    }
    
    func invocationRequest(requestId: String, msg: AzureFunctionsRpcMessages_InvocationRequest) throws {
        
        var res = AzureFunctionsRpcMessages_InvocationResponse()
        res.invocationID = msg.invocationID
        
        if let function: Function = registry.byId(id: msg.functionID), let functionInfo: FunctionInfo = registry.infoById(id: msg.functionID) {
            
            var inputBindings: [String: Any] = [:]
            
            var triggerInput: Any?
            
            for binding in msg.inputData {
                
                if function.trigger!.name == binding.name {
                    
                    if let ti = try BindingFactory.buildBinding(bindingDefinition: function.trigger!, rpcBinding: functionInfo.inputBindings[binding.name]!, binding: binding, metadata: msg.triggerMetadata) {
                        triggerInput = ti
                    } else {
                        triggerInput = try RpcConverter.fromTypedData(data: binding.data)
                    }
                    
                } else {
                    if let bindingDef = function.inputBindingsDic[binding.name], let inputBidning = try BindingFactory.buildBinding(bindingDefinition: bindingDef, rpcBinding: functionInfo.inputBindings[binding.name]!, binding: binding, metadata: nil) {
                        
                        inputBindings[binding.name] = inputBidning
                    } else {
                        inputBindings[binding.name] = try RpcConverter.fromTypedData(data: binding.data)
                    }
                }
                
            }
            
            var context = Context()
            context.inputBindings = inputBindings
            
            do {
                try Broker.run(function: function, input: triggerInput, context: &context) { [weak context, self]  result in
                    
                    if (result as? Bool) != true {
                        res.returnValue = RpcConverter.toRpcTypedData(obj: result)
                    }
                    
                    res.result = self.successStatusResult(nil)
                    
                    if let http: String = functionInfo.httpOutputBinding, context!.bindings[http] == nil, let httpRes = result as? HttpResponse {
                        context!.bindings[http] = httpRes
                    }
                    
                    context!.prepBindings()
                    
                    res.outputData = functionInfo.outputBindings
                        .filter({ (key, val) -> Bool in
                            return context!.bindings[key] != nil
                        }).map({ (key, binding) -> AzureFunctionsRpcMessages_ParameterBinding in
                            
                            var paramBinding = AzureFunctionsRpcMessages_ParameterBinding()
                            paramBinding.name = key
                            
                            var td = AzureFunctionsRpcMessages_TypedData()
                            td = RpcConverter.toRpcTypedData(obj:context!.bindings[key]!)
                            paramBinding.data = td
                            
                            return paramBinding
                        })
                    
                    self.sendMessage(content: .invocationResponse(res), requestId: requestId)
                }
            } catch {
                res.result = failureStatusResult(result: "Exception while executing Function \(function.name ?? "")", exceptionMessage: error.localizedDescription, source: function.name)
                sendMessage(content: .invocationResponse(res), requestId: requestId)
            }
        } else {
            res.result = failureStatusResult(result: "Cannot execute Function: not found", exceptionMessage: nil, source: nil)
            sendMessage(content: .invocationResponse(res), requestId: requestId)
        }
    }
    
    
    func invocationCancel(requestId: String, msg: AzureFunctionsRpcMessages_InvocationCancel) {
        // Not Implemented
    }
    
    func functionEnvironmentReloadRequest(requestId: String, msg: AzureFunctionsRpcMessages_FunctionEnvironmentReloadRequest) {
        var envVars = ProcessInfo.processInfo.environment
        
        var res = AzureFunctionsRpcMessages_FunctionEnvironmentReloadResponse()
        var stRes = AzureFunctionsRpcMessages_StatusResult.init()
        
        envVars.merge(msg.environmentVariables) { (_, new) -> String in new }
        Process().environment = envVars
        stRes.status = .success
        
        res.result = stRes
        sendMessage(content: .functionEnvironmentReloadResponse(res), requestId: requestId)
        
    }
}

// Helpers
extension WorkerChannel {
    
    func sendMessage(content: AzureFunctionsRpcMessages_StreamingMessage.OneOf_Content, requestId: String) {
        var resMsg = AzureFunctionsRpcMessages_StreamingMessage()
        resMsg.requestID = requestId
        resMsg.content = content
        
        eventStream.sendMessage(resMsg, promise: nil)
    }
    
    func successStatusResult(_ result: String?) -> AzureFunctionsRpcMessages_StatusResult {
        var stRes = AzureFunctionsRpcMessages_StatusResult.init()
        stRes.status = .success
        if let res = result {
            stRes.result = res
        }
        return stRes
    }
    
    func failureStatusResult(result: String, exceptionMessage: String?, source: String?) -> AzureFunctionsRpcMessages_StatusResult {
        var stRes = AzureFunctionsRpcMessages_StatusResult.init()
        stRes.status = .failure
        stRes.result = result
        
        if let ex = exceptionMessage {
            var exception = AzureFunctionsRpcMessages_RpcException()
            exception.message = ex
            if let src = exceptionMessage {
                exception.source = src
            }
        }
        
        return stRes
    }
    
}
