//
//  ServiceBus.swift
//  SwiftFunc
//
//  Created by Saleh on 10/26/19.
//

import Foundation

public class Queue: Binding {
    
    public var name: String = ""
    public var queueName: String = ""
    public var connection: String = ""
    public var metadata: [String:String] = [:]
    public var properties: [String:String] = [:]
    
    internal init() {
        
    }
    
    public init(name: String, queueName: String, connection: String) {
        self.name = name
        self.queueName = queueName
        self.connection = connection
    }
    
    struct Keys {
        static let Queue = "queueName"
    }
}

extension Queue: BindingCapability {
    
    var isInput: Bool {
        return false
    }
    
    var isOutput: Bool {
        return true
    }
    
    var isTrigger: Bool {
        return true
    }
    
    
    static let triggerTypeKey = "queueTrigger"
    static let typeKey = "queue"
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.Name: name,
            Definitions.Bindings.Keys.Connection: connection,
            Keys.Queue : queueName
        ]
        
        switch direction {
        case .trigger:
            props[Definitions.Bindings.Keys.TypeKey] = Queue.triggerTypeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionIn
            break
        case .output:
            props[Definitions.Bindings.Keys.TypeKey] = Queue.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionOut
            break
        default:
            throw FunctionError.internalInconsistancyException("Error generating bidining description")
        }
        
        return props
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
           return try jsonDescription(direction: direction).toJsonString()
      }
    
}
