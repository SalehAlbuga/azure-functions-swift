//
//  ServiceBusMessage.swift
//  SwiftFunc
//
//  Created by Saleh on 10/26/19.
//

import Foundation

public class ServiceBusMessage: Binding {
    
    public var name: String = ""
    public var queueName: String?
    public var topicName: String?
    public var subscriptionName: String?
    public var connection: String = ""
    public var message: Any?
    
    internal init() {
        
    }
    
    public init(name: String, queueName: String, connection: String) {
        self.name = name
        self.queueName = queueName
        self.connection = connection
    }
    
    public init(name: String, topicName: String, subscriptionName: String, connection: String) {
        self.name = name
        self.topicName = topicName
        self.subscriptionName = subscriptionName
        self.connection = connection
    }
    
    struct Keys {
        static let TopicName = "topicName"
        static let QueueName = "queueName"
        static let SubscriptionName = "subscriptionName"
    }
}

extension ServiceBusMessage: BindingCapability {
    
    var isInput: Bool {
        return false
    }
    
    var isOutput: Bool {
        return true
    }
    
    var isTrigger: Bool {
        return true
    }
    
    
    static let triggerTypeKey = "serviceBusTrigger"
    static let typeKey = "serviceBus"
    
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.Name: name,
            Definitions.Bindings.Keys.Connection: connection,
        ]
        
        if let topic = self.topicName {
            props[Keys.TopicName] = topic
        }
        
        if let queue = self.queueName {
            props[Keys.QueueName] = queue
        }
        
        switch direction {
        case .trigger:
            props[Definitions.Bindings.Keys.TypeKey] = ServiceBusMessage.triggerTypeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionIn
            if let subscription = self.subscriptionName {
                props[Keys.SubscriptionName] = subscription
            }
            break
        case .output:
            props[Definitions.Bindings.Keys.TypeKey] = ServiceBusMessage.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionOut
            break
        default:
            throw FunctionError.internalInconsistancyException("Error generating bidining description")
        }
        
        return props
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
        return  try jsonDescription(direction: direction).toJsonString()
    }
    
}
