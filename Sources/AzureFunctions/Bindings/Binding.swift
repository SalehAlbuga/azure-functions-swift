//
//  Binding.swift
//  SwiftFunc
//
//  Created by Saleh on 10/25/19.
//

import Foundation

public protocol Binding {
    var name: String { get set }
}

internal enum BindingDirection {
    case trigger
    case input
    case output
}

internal protocol BindingCapability {
    var isInput: Bool { get }
    var isOutput: Bool { get }
    var isTrigger: Bool { get }
    
    static var triggerTypeKey: String { get }
    static var typeKey: String { get }

    func jsonDescription(direction: BindingDirection) throws -> [String:Any]
    func stringJsonDescription(direction: BindingDirection) throws -> String
    
}

