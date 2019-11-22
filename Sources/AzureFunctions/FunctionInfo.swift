//
//  FunctionInfo.swift
//  SwiftFunc
//
//  Created by Saleh on 10/5/19.
//

import Foundation

internal final class FunctionInfo {
    
    var httpOutputBinding: String?
    var bindings: [String: AzureFunctionsRpcMessages_BindingInfo] = [:]
    
    init() { }
    
    init(withBindings: [String: AzureFunctionsRpcMessages_BindingInfo]) {
        self.bindings = withBindings
        getHttpOutputName()
    }
    
    lazy var outputBindings: [String: AzureFunctionsRpcMessages_BindingInfo] = {
        return bindings.filter { (key, val) -> Bool in
            return val.direction == .out
        }
    }()
    
    lazy var inputBindings: [String: AzureFunctionsRpcMessages_BindingInfo] = {
        return bindings.filter { (key, val) -> Bool in
            return val.direction == .in
        }
    }()
    
   fileprivate func getHttpOutputName() {
        for binding in outputBindings {
            if binding.value.type == "http" {
                self.httpOutputBinding = binding.key
            }
        }
    }
    
    static func getInputsAndBindings(input: AzureFunctionsRpcMessages_TypedData) -> Any?  {
        return nil
    }
}
