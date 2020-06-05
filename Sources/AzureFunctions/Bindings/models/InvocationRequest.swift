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
    
   public var Data: [String:AnyCodable]?
   public var Metadata: [String:AnyCodable]?
    
   public enum CodingKeys: String, CodingKey {

        case data = "Data"
        case metadata = "Metadata"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Data = try values.decode([String:AnyCodable].self, forKey: .data)
        Metadata = try values.decode([String:AnyCodable].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Data, forKey: .data)
        try container.encode(Metadata, forKey: .metadata)
    }
    
}
