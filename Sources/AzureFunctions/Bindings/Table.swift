//
//  Table.swift
//  SwiftFunc
//
//  Created by Saleh on 10/27/19.
//

import Foundation

public class Table: Binding {
    
    public var name: String = ""
    public var tableName: String = ""
    public var connection: String = ""
    public var partitionKey: String?
    public var rowKey: String?
    public var take: String?
    public var filter: String?
    
    internal init() {
        
    }
    
    public init(inputName name: String, tableName: String, connection: String, partitionKey: String? = nil, rowKey: String? = nil, take: String? = nil, filter: String? = nil) {
        self.name = name
        self.tableName = tableName
        self.connection = connection
        self.partitionKey = partitionKey
        self.rowKey = rowKey
        self.take = take
        self.filter = filter
    }
    
    public init(outputName name: String, tableName: String, connection: String, partitionKey: String, rowKey: String) {
        self.name = name
        self.tableName = tableName
        self.connection = connection
        self.partitionKey = partitionKey
        self.rowKey = rowKey
    }
    
    struct Keys {
        static let TableName = "tableName"
        static let PartitionKey = "partitionKey"
        static let RowKey = "rowKey"
        static let Take = "take"
        static let Filter = "filter"
    }
}

extension Table: BindingCapability {
    
    
    var isInput: Bool {
        return true
    }
    
    var isOutput: Bool {
        return true
    }
    
    var isTrigger: Bool {
        return false
    }
    
    
    static let typeKey = "table"
    static var triggerTypeKey: String {
        return ""
    }
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.Name: name,
            Definitions.Bindings.Keys.Connection: connection,
            Keys.TableName: tableName
        ]
        
        switch direction {
        case .input:
            props[Definitions.Bindings.Keys.TypeKey] = Table.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionIn
            
            if let partition = partitionKey {
                props[Keys.PartitionKey] = partition
            }
            
            if let row = rowKey {
                props[Keys.RowKey] = row
            }
            
            if let take = take {
                props[Keys.Take] = take
            }
            
            if let filter = filter {
                props[Keys.Filter] = filter
            }
            
            break
        case .output:
            props[Definitions.Bindings.Keys.TypeKey] = Table.typeKey
            props[Definitions.Bindings.Keys.Direction] = Definitions.Bindings.DirectionOut
            
            if let partition = partitionKey {
                props[Keys.PartitionKey] = partition
            }
            
            if let row = rowKey {
                props[Keys.RowKey] = row
            }
            
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
