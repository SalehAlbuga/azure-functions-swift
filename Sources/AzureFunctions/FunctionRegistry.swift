//
//  FunctionRegistry.swift
//  SwiftFunc
//
//  Created by Saleh on 11/1/19.
//

import Foundation

public final class FunctionRegistry {
    
    internal var functionsByName: [String: Function] = [:]
    private var functionsById: [String: Function] = [:]
    private var functionsInfo: [String: FunctionInfo] = [:]
    
    public var AzureWebJobsStorage: String?
    public var EnvironmentVariables: [String: String]?
    
    public var ExtensionBundleId: String?
    public var ExtensionBundleVersion: String?
    
    public init() { }
    
    public init(AzureWebJobsStorage: String) {
        self.AzureWebJobsStorage = AzureWebJobsStorage
    }
    
    public init(AzureWebJobsStorage: String, EnvironmentVariables: [String: String]) {
        self.AzureWebJobsStorage = AzureWebJobsStorage
        self.EnvironmentVariables = EnvironmentVariables
    }
    
    public func register(_ function: Function.Type) {
        let fun = function.init()
        self.functionsByName[fun.name] = fun
    }
    
    internal func register(id: String, forName: String) {
        functionsByName[forName]?.id = id
        self.functionsById[id] = functionsByName[forName]
    }
    
    internal func registerInfo(id: String, info: FunctionInfo) {
        self.functionsInfo[id] = info
    }
    
    internal func byId(id: String) -> Function? {
        return functionsById[id]
    }
    
    internal func byName(name: String) -> Function? {
        return functionsByName[name]
    }
    
    internal func infoById(id: String) -> FunctionInfo? {
        return functionsInfo[id]
    }
    
    internal func validateBindings() {
        for function in functionsByName.values {
            function.validateBindings()
        }
    }
    
}
