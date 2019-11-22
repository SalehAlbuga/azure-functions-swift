//
//  Blob.swift
//  SwiftFunc
//
//  Created by Saleh on 10/25/19.
//

import Foundation

public class Blob: Binding {
    
    public var name: String = ""
    public var connection: String = ""
    public var path: String = ""
    public var url: String = ""
    public var blob: Any?
    public var metadata: [String:String] = [:]
    public var properties: [String:String] = [:]
    
    internal init() {
        
    }
    
    public init(name: String, path: String, connection: String) {
        self.name = name
        self.path = path
        self.connection = connection
    }
    
    struct Keys {
        static let Connection = "connection"
        static let Path = "path"
    }
}

extension Blob: BindingCapability {
    
    var isInput: Bool {
        return true
    }
    
   var isOutput: Bool {
        return true
    }
    
   var isTrigger: Bool {
        return true
    }
    
    
    static let triggerTypeKey = "blobTrigger"
    static let typeKey = "blob"
    
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.Name: name,
            Blob.Keys.Connection: connection,
            Blob.Keys.Path: path
        ]
        
        switch direction {
        case .trigger:
            props[Definitions.Bindings.Keys.TypeKey] = Blob.triggerTypeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionIn
            break
        case .input:
            props[Definitions.Bindings.Keys.TypeKey] = Blob.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionIn
            break
        case .output:
            props[Definitions.Bindings.Keys.TypeKey] = Blob.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionOut
            break
        }
        
        return props
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
           return  try jsonDescription(direction: direction).toJsonString()
      }
    
}
