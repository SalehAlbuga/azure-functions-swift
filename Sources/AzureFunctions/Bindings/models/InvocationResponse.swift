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
    
    var Outputs: [String:AnyCodable]?
    var Logs: [String] = []
    var ReturnValue: AnyCodable?
    
    enum CodingKeys: String, CodingKey {
         
        case Output = "Outputs"
        case Logs = "Logs"
        case ReturnValue = "ReturnValue"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Outputs = try container.decode([String:AnyCodable].self, forKey: .Output)
        Logs = try container.decode([String].self, forKey: .Logs)
        ReturnValue = try container.decode(AnyCodable.self, forKey: .ReturnValue)
    }
    
    public init() { }
    
    public init(outputs: [String:AnyCodable], logs: [String] = [], returnValue: AnyCodable? = nil) {
        self.Outputs = outputs
        Logs = logs
        ReturnValue = returnValue
    }
    
    public init(logs: [String] = [], returnValue: AnyCodable? = nil) {
        self.Outputs = nil
        Logs = logs
        ReturnValue = returnValue
    }
    
    public static func response(with outputs: [String:AnyCodable], logs: [String] = [], returnValue: AnyCodable? = nil) -> Data {
        let res = InvocationResponse(outputs: outputs, logs: logs, returnValue: returnValue)
        return try! JSONEncoder().encode(res)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Outputs, forKey: .Output)
        try container.encode(Logs, forKey: .Logs)
        try container.encode(ReturnValue, forKey: .ReturnValue)
    }
    
}

public extension InvocationResponse {
    
    mutating func appendLog(_ log: String) {
        Logs.append(log)
    }
    
    mutating func removeLastLog() {
        Logs.removeLast()
    }
    
}
