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
    
    /// Default Azure Function storage
    public var AzureWebJobsStorage: String?
    /// Environment variables dictionary
    public var EnvironmentVariables: [String: String]?
    
    /// Extensions Bundle id (do not change unless needed, defaults to Microsoft.Azure.Functions.ExtensionBundle)
    public var ExtensionBundleId: String?
    /// Extensions Bundle version (do not change unless needed, defaults to [1.*, 2.0.0))
    public var ExtensionBundleVersion: String?
    
    public init() { }
    
    public init(AzureWebJobsStorage: String) {
        self.AzureWebJobsStorage = AzureWebJobsStorage
    }
    
    public init(AzureWebJobsStorage: String, EnvironmentVariables: [String: String]) {
        self.AzureWebJobsStorage = AzureWebJobsStorage
        self.EnvironmentVariables = EnvironmentVariables
    }
    
    /// Registers a Function
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
