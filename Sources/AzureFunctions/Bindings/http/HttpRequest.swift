//
//  HttpRequest.swift
//  SwiftFunc
//
//  Created by Saleh on 9/21/19.
//

import Foundation

public final class HttpRequest : Binding {
    
    public var name: String = ""
    public var route: String?
    public var methods: [String] = []
    public var method: String = ""
    public var url: String = ""
    public var originalUrl: String = ""
    public var headers: [String:String] = [:]
    public var query: [String:String] = [:]
    public var params: [String:String] = [:]
    public var body: Data?
    public var rawBody: Data?
    
    internal init() { }
    
    public init(name: String, route: String = "", methods: [String] = []) {
        if name != "" {
            self.name = name
        } else {
            self.name = "req"
        }
        if route != "" {
            self.route = route
        }
        self.methods = methods
    }
    
    
    internal init(fromRpcHttp: AzureFunctionsRpcMessages_RpcHttp) {
        
        self.method = fromRpcHttp.method
        self.url = fromRpcHttp.url
        self.headers = fromRpcHttp.headers
        self.query = fromRpcHttp.query
        
        let data = fromRpcHttp.body.bytes
        self.body = data
        
        let rawData = fromRpcHttp.rawBody.bytes
        self.rawBody = rawData
    }
    
    struct Keys {
        static let Methods = "methods"
        static let Route = "route"
    }
    
}

extension HttpRequest: BindingCapability {
    static let triggerTypeKey: String = "httpTrigger"
    
    static let typeKey: String = ""
    
    var isInput: Bool {
        return false
    }
    
    var isOutput: Bool {
        return false
    }
    
    var isTrigger: Bool {
        return true
    }
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.TypeKey: HttpRequest.triggerTypeKey,
            Definitions.Bindings.Keys.Name: name,
            Definitions.Bindings.Keys.Direction: Definitions.Bindings.DirectionIn,
        ]
        
        if methods.count > 0 {
            props[HttpRequest.Keys.Methods] = methods
        }
        
        if let rt = route {
            props[HttpRequest.Keys.Route] = rt
        }
        
        switch direction {
        case .trigger:
            return props
        default:
            throw FunctionError.internalInconsistancyException("Error generating bidining description")
        }
        
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
       return try jsonDescription(direction: direction).toJsonString()
    }
    
}
