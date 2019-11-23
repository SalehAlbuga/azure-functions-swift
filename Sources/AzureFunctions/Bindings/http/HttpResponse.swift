import Foundation

public final class HttpResponse: Binding {
    
    public var name: String

    public var statusCode: Int?
    public var headers: [String:String] = [:]
    // TODO var cookies: [Cookie] = []
    public var body: Data?
    public var enableContentNegotiation: Bool?
    public var params: [String:String] = [:]
    public var query: [String:String] = [:]
    
    public init () {
        self.name = ""
        self.headers["X-Powered-By"] = "SwiftFunc"
    }
    
    public init(bindingName: String) {
        self.name = bindingName
    }
    
    func toRpcHttp() -> AzureFunctionsRpcMessages_RpcHttp {
        var rpc = AzureFunctionsRpcMessages_RpcHttp()
        rpc.statusCode = "\(statusCode ?? 200)"
        rpc.headers = self.headers
        
        if let data = body {
            var typedData = AzureFunctionsRpcMessages_TypedData()
            typedData.data = .bytes(data)
            rpc.body = typedData
        }
        
        if let contentNegotiation = self.enableContentNegotiation {
            rpc.enableContentNegotiation = contentNegotiation
        }
        
        rpc.params = params
        rpc.query = query
        
        return rpc
    }

}

extension HttpResponse: BindingCapability {
    static var triggerTypeKey: String {
        return ""
    }
    
    static var typeKey: String = "http"
    
    
    var isInput: Bool {
        return false
    }
    
    var isOutput: Bool {
        return true
    }
    
    var isTrigger: Bool {
        return false
    }
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.TypeKey: HttpResponse.typeKey,
//            Definitions.Bindings.Keys.Name: name == "" ? name : "$return",
            Definitions.Bindings.Keys.Direction: Definitions.Bindings.DirectionOut,
        ]
        
        if name != "" {
            props[Definitions.Bindings.Keys.Name] = name
        } else {
            props[Definitions.Bindings.Keys.Name] = "$return"
        }
        
        switch direction {
        case .output:
            return props
        default:
            throw FunctionError.internalInconsistancyException("Error generating bidining description")
        }
        
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
        return try jsonDescription(direction: direction).toJsonString()
      }
    
    
}

// TODO
class Cookie {
    var name: String = ""
    var value: String = ""
    var domain: String?
    var path: String? 
    var secures: Bool?
    var httpOnly: Bool?
    var sameSite: String? // "Strict" | "Lax" | undefined;
    var maxAge: Int?
    
//    func toRpcHttp() -> AzureFunctionsRpcMessages_RpcHttp {
//        
//    }
}

