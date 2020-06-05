//
//  Function.swift
//  SwiftFunc
//
//  Created by Saleh on 9/28/19.
//

import Foundation
import AnyCodable
import Vapor

enum FunctionError: Error {
    case FunctionTypeNotImplementedException(String)
    case internalInconsistancyException(String)
    case JSONSerializationException(String)
}

public typealias callback = (Any) -> Void

open class Function {
    
    public var name: String!
    
    public var id: String!
    
    internal var inputBindingsDic: [String: Binding] = [:]
    internal var outputBindingsDic: [String: Binding] = [:]
    
    public var inputBindings: [Binding] = []
    public var outputBindings: [Binding] = []
    public var isDisabled: Bool = false
    
    public var trigger: Binding!
    
    public var functionJsonBindings: [[String: Any]] = []
    public var app: Application = HandlerHTTPServer.shared.app
    
    
    public required init() {
        
    }
    
    open func exec(request: HttpRequest, context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(timer: TimerTrigger, context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(data: Data, context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(string: String, context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(dictionary: [String: Any], context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(blob: Blob, context: inout Context, callback: @escaping callback) throws {
        throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    open func exec(sbMessage: ServiceBusMessage, context: inout Context, callback: @escaping callback) throws {
           throw FunctionError.FunctionTypeNotImplementedException("Please override the right exec function for your trigger")
    }
    
    
}

internal extension Function {
    
    func convertInputsToDictionary() {
        for binding in self.inputBindings {
            self.inputBindingsDic[binding.name] = binding
        }
    }
    
    func validateBindings() {
        
        if functionJsonBindings.count > 0 {
            return
        } else if functionJsonBindings.count == 0 && inputBindings.count == 0 && outputBindings.count == 0 && trigger == nil {
            fatalError("No bindings or trigger defined. Please set functionJsonBindings or trigger and other binding properties")
        } else {
            
            for binding in inputBindings {
                if (binding as! BindingCapability).isInput == false {
                    fatalError("\(binding.self) of Function \(self.name!) is not an input binding")
                }
            }
            
            for binding in outputBindings {
                if (binding as! BindingCapability).isOutput == false {
                    fatalError("\(binding.self) of Function \(self.name!) is not an output binding")
                }
                
                //            precondition((binding as! BindingCapability).isOutput == true, "\(Logger.LogPrefix) \(binding.self) is not an output binding")
            }
            
            //        precondition((trigger as! BindingCapability).isTrigger == true, "\(Logger.LogPrefix) \(String(describing: trigger.self)) is not a trigger")
            if (trigger as! BindingCapability).isTrigger == false { fatalError("\(String(describing: trigger.self)) of Function \(self.name!) is not a trigger") }
        }
    }
    
}


// Codegen
internal extension Function {
    func getFunctionJsonBindings() throws -> String {
        
        var bindings: [[String:Any]] = []
        
        if functionJsonBindings.count > 0 {
            for binding in functionJsonBindings {
                bindings.append(binding)
            }
        }
        
        if trigger != nil {
            bindings.append(try (trigger as! BindingCapability).jsonDescription(direction: .trigger))
        }
        
        for binding in inputBindings {
            bindings.append(try (binding as! BindingCapability).jsonDescription(direction: .input))
        }
        
        for binding in outputBindings {
            bindings.append(try (binding as! BindingCapability).jsonDescription(direction: .output))
        }
        
        if trigger is HttpRequest && (outputBindings.count == 0 || !outputBindings.contains { (binding) -> Bool in
            return binding is HttpResponse
            }) {
            bindings.append(try HttpResponse(bindingName: "$return").jsonDescription(direction: .output))
        }
        
        let dic: [String : Any] = ["generatedBy": "azure-functions-swift",
                                   "disabled": isDisabled,
                                   "bindings": bindings
        ]
        
        return try dic.toJsonString()
    }
    
}
