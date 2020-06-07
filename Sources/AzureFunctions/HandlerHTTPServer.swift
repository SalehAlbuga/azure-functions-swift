//
//  HandlerHTTPServer.swift
//  SwiftFunc
//
//  Created by Saleh on 5/19/20.
//

import Foundation
import Vapor

internal final class HandlerHTTPServer {
    
    internal static let shared = HandlerHTTPServer()
    
    var app: Application
    
    private init()  {
        app = Application.init()
        app.environment = .production
    }
    
    func startHttpWorker(port: Int, registry: FunctionRegistry, workerId: String?) throws {
        app.http.server.configuration.port = port
        
        try app.server.start()
        dispatchMain()
    }
    
}
