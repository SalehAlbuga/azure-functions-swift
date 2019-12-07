//
//  Context.swift
//  SwiftFunc
//
//  Created by Saleh on 10/5/19.
//

import Foundation

public final class Context {
    
    internal var bindings: [String: Any] = [:]
    
    public var inputBindings: [String: Any] = [:]
    public var outputBindings: [String: Any] = [:]
    
    internal init () { }
    
    internal func prepBindings() {
        self.bindings = inputBindings
        self.bindings.merge(self.outputBindings) { (current, _) -> Any in
            current
        }
    }
    
    public func log(_ message: String) {
        Logger.log(message)
    }
    
}
