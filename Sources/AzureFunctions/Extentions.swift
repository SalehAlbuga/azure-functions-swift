//
//  Converters.swift
//  SwiftFunc
//
//  Created by Saleh on 11/2/19.
//

import Foundation

extension Dictionary {
    
    func toJsonString() throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String(bytes: jsonData, encoding: String.Encoding.utf8)?.backslashCorrected ?? "invalidJson"
    }
}

extension String {
    
    var backslashCorrected: String { // Workaround
        let corrected : String = self.replacingOccurrences(of: "\\/", with: "/")
        return corrected
    }
    
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
}
