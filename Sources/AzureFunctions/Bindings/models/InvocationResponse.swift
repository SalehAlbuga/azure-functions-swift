//
//  InvocationResponse.swift
//  SwiftFunc
//
//  Created by Saleh on 5/20/20.
//

import Foundation
import AnyCodable
import Vapor

public struct InvocationResponse: Content {
    
    /// Output bindings values dictionary
    var outputs: [String:AnyCodable]?
    /// Functions logs array. These will be logged when the Function is executed
    var logs: [String] = []
    /// The $return binding value
    var returnValue: AnyCodable?
    
    enum CodingKeys: String, CodingKey {
        case Output = "Outputs"
        case Logs = "Logs"
        case ReturnValue = "ReturnValue"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        outputs = try container.decode([String:AnyCodable].self, forKey: .Output)
        logs = try container.decode([String].self, forKey: .Logs)
        returnValue = try container.decode(AnyCodable.self, forKey: .ReturnValue)
    }
    
    public init() { }
    
    public init(outputs: [String:AnyCodable], logs: [String] = [], returnValue: AnyCodable? = nil) {
        self.outputs = outputs
        self.logs = logs
        self.returnValue = returnValue
    }
    
    public init(logs: [String] = [], returnValue: AnyCodable? = nil) {
        self.outputs = nil
        self.logs = logs
        self.returnValue = returnValue
    }
    
    public static func response(with outputs: [String:AnyCodable], logs: [String] = [], returnValue: AnyCodable? = nil) -> Data {
        let res = InvocationResponse(outputs: outputs, logs: logs, returnValue: returnValue)
        return try! JSONEncoder().encode(res)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(outputs, forKey: .Output)
        try container.encode(logs, forKey: .Logs)
        try container.encode(returnValue, forKey: .ReturnValue)
    }
    
}

public extension InvocationResponse {
    
    mutating func appendLog(_ log: String) {
        logs.append(log)
    }
    
    mutating func removeLastLog() {
        logs.removeLast()
    }
    
}
