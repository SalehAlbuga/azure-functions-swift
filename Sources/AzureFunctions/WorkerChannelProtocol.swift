//
//  FunctionsProvider.swift
//  SwiftFunc
//
//  Created by Saleh on 9/6/19.
//

import Foundation

internal protocol WorkerChannelProtocol {
    func startStream(requestId: String, msg: AzureFunctionsRpcMessages_StartStream) -> Void
    func workerInitRequest(requestId: String, msg: AzureFunctionsRpcMessages_WorkerInitRequest) -> Void
    func workerHeartbeat(requestId: String, msg: AzureFunctionsRpcMessages_WorkerHeartbeat) -> Void
    func workerTerminate(requestId: String, msg: AzureFunctionsRpcMessages_WorkerTerminate) -> Void
    func workerStatusRequest(requestId: String, msg: AzureFunctionsRpcMessages_WorkerStatusRequest) -> Void
    func fileChangeEventRequest(requestId: String, msg: AzureFunctionsRpcMessages_FileChangeEventRequest) -> Void
    func functionLoadRequest(requestId: String, msg: AzureFunctionsRpcMessages_FunctionLoadRequest) -> Void
    func invocationRequest(requestId: String, msg: AzureFunctionsRpcMessages_InvocationRequest) throws -> Void
    func invocationCancel(requestId: String, msg: AzureFunctionsRpcMessages_InvocationCancel) -> Void
    func functionEnvironmentReloadRequest(requestId: String, msg: AzureFunctionsRpcMessages_FunctionEnvironmentReloadRequest) -> Void

}

