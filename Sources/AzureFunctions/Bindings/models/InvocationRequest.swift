//
//  InvocationRequest.swift
//  SwiftFunc
//
//  Created by Saleh on 5/20/20.
//

import Foundation
import AnyCodable
import Vapor

public struct InvocationRequest: Content {
    
    /// Trigger/Bindings data (values).
    public var data: [String:AnyCodable]?
    /// Trigger/Bindings metadata.
    public var metadata: [String:AnyCodable]?
    
    public enum CodingKeys: String, CodingKey {
        
        case data = "Data"
        case metadata = "Metadata"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode([String:AnyCodable].self, forKey: .data)
        metadata = try values.decode([String:AnyCodable].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(metadata, forKey: .metadata)
    }
    
}
