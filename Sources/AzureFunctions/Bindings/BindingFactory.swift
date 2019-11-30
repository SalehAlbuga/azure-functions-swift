//
//  BindingFactory.swift
//  SwiftFunc
//
//  Created by Saleh on 10/17/19.
//

import Foundation


internal final class BindingFactory {
    
    static func buildBinding(bindingDefinition: Binding, rpcBinding: AzureFunctionsRpcMessages_BindingInfo, binding: AzureFunctionsRpcMessages_ParameterBinding, metadata: Dictionary<String,AzureFunctionsRpcMessages_TypedData>?) throws -> Binding? {
        switch bindingDefinition {
        case let http as HttpRequest:
            if rpcBinding.type == "http" || rpcBinding.type == "httpTrigger" {
                let httpReq = try RpcConverter.fromTypedData(data: binding.data) as! HttpRequest
                httpReq.name = http.name
                httpReq.route = http.route
                return httpReq
            } else {
                throw FunctionError.internalInconsistancyException("Expected http binding type, got \(rpcBinding.type). Please make sure function.json matches the function definition.")
            }
        case let timer as TimerTrigger:
            if rpcBinding.type == TimerTrigger.triggerTypeKey {
                let json = try RpcConverter.fromTypedData(data: binding.data) as! [String:Any]
                let t = TimerTrigger()
                t.userInfo = json
                t.name = timer.name
                t.schedule = timer.schedule
                return t
            } else {
                throw FunctionError.internalInconsistancyException("Expected timer binding type, got \(rpcBinding.type). Please make sure function.json matches the function definition.")
            }
        case let b as Blob:
            if rpcBinding.type == Blob.typeKey || rpcBinding.type == Blob.triggerTypeKey {
                let blob = Blob()
                blob.blob = try RpcConverter.fromTypedData(data: binding.data)
                
                blob.name = b.name
                blob.path = b.path
                if let meta = metadata, let props = meta["properties"] {
                    blob.properties = try RpcConverter.fromTypedData(data: props) as! [String:String]
                }
                return blob
            } else {
                throw FunctionError.internalInconsistancyException("Expected blob binding type, got \(rpcBinding.type). Please make sure function.json matches the function definition.")
            }
        case let sb as ServiceBusMessage:
            if rpcBinding.type == ServiceBusMessage.triggerTypeKey {
                
               let sbMsg = ServiceBusMessage()
                sbMsg.name = sb.name
                sbMsg.message = try RpcConverter.fromTypedData(data: binding.data, preferJsonInString: true)
                sbMsg.queueName = sb.queueName
                sbMsg.topicName = sb.topicName
                sbMsg.subscriptionName = sb.subscriptionName
                
                return sbMsg
            } else {
                throw FunctionError.internalInconsistancyException("Expected blob binding type, got \(rpcBinding.type). Please make sure function.json matches the function definition.")
            }
        case _ as Queue, _ as Table:
            return nil
        default:
            throw FunctionError.internalInconsistancyException("Cannot build binding for type of '\(binding.name)'")
        }
    }
    
}

