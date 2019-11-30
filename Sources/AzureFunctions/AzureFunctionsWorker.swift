//
//  LanguageWorker.swift
//  SwiftFunc
//
//  Created by Saleh on 11/1/19.
//

import Foundation

public final class AzureFunctionsWorker {
    
    public static let shared = AzureFunctionsWorker()
    
    private init () { }
    internal var worker: WorkerChannel!
    
    
    public func main(registry: FunctionRegistry) {
        
        #if !os(Linux)
        NSSetUncaughtExceptionHandler { (exception) in
            Logger.log("EXCEPTION")
            Logger.log(exception.description)
            Logger.log(exception.callStackSymbols.description)
            exit(1)
        }
        #endif
        
        
        registry.validateBindings()
        
        let args = CommandLine.arguments
        
        if args.contains("export"), let rootPathIdx = args.firstIndex(of: "--root"), let sourcePathIdx = args.firstIndex(of: "--source") {
            
            let sourcePath = args[sourcePathIdx+1]
            let rootPath = args[rootPathIdx+1]
            
            var isDebug: Bool = false
            if let _ = args.firstIndex(of: "--debug") {
                isDebug = true
            }
            
            do {
                try CodeGen.exportScriptRoot(registry: registry, sourceDir: sourcePath, rootDir: rootPath, debug: isDebug)
            } catch {
                exit(1)
            }
            exit(0)
            
        } else if args.contains("functions-metadata"), let nameIdx = args.firstIndex(of: "--name") {
            let funcName = args[nameIdx+1]
            
            do {
                if let function = registry.byName(name: funcName) {
                    let bindings = try function.getFunctionJsonBindings()
                    print(bindings)
                    exit(0)
                } else {
                    print("function not found")
                    exit(1)
                }
            } catch {
                print("error generating bindings \(error.localizedDescription)")
                exit(1)
            }
            
            
        } else {
            guard args.contains("run"), let hostIndex = args.firstIndex(of: "--host"), let portIndex = args.firstIndex(of: "--port"), let reqIdIndex = args.firstIndex(of: "--requestId"), let wrkrIdIndex = args.firstIndex(of: "--workerId"), let msgLenIndex = args.firstIndex(of: "--grpcMaxMessageLength") else {
                print("Azure Functions for Swift worker 0.0.1")
                print("Please provide command, host and port and host args")
                Logger.log("Please provide command, host and port and host args")
                exit(1)
                //        return
            }
            
            let host = args[hostIndex+1]
            let port = args[portIndex+1]
            let reqId = args[reqIdIndex+1]
            let workerId = args[wrkrIdIndex+1]
            let messageLengthStr = args[msgLenIndex+1]
            if let msgLen = Int32.init(messageLengthStr) {
                startWorker(host: host, port: port, reqId: reqId, workerId: workerId, msgLen: msgLen, registry: registry)
            } else {
                print("Azure Functions for Swift worker 0.0.1")
                print("MessageLength required")
                Logger.log("MessageLength required")
                exit(1)
            }
        }
        
    }
    
    func startWorker(host: String, port :String, reqId: String, workerId: String, msgLen: Int32, registry: FunctionRegistry) {
        worker = WorkerChannel(workerId: workerId, requestId: reqId, messageLength: msgLen, registry: registry)
        worker.runClient(host: host, port: Int(port)!)
    }
}
