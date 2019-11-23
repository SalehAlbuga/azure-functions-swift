//
//  Timer.swift
//  SwiftFunc
//
//  Created by Saleh on 10/25/19.
//

import Foundation

public final class TimerTrigger : Binding {
    
    public var name: String = ""
    
    var schedule: String = ""

    var runOnStartup: Bool?
    var useMonitor: Bool?
    
    var userInfo: [String:Any] = [:]
    
    internal init () {
        
    }
    
    public init(name: String, schedule: String) {
        self.schedule = schedule
        self.name = name
    }
    
    public init(name: String, schedule: String, runOnStartup: Bool, useMonitor: Bool) {
        self.schedule = schedule
        self.name = name
        self.runOnStartup = runOnStartup
        self.useMonitor = useMonitor
    }
    
    struct Keys {
        static let Schedule = "schedule"
        static let RunOnStartup = "runOnStartup"
        static let UseMonitor = "UseMonitor"
    }
    
}

extension TimerTrigger: BindingCapability {
    
    
    var isInput: Bool {
        return false
    }
    
    var isOutput: Bool {
        return false
    }
    
     var isTrigger: Bool {
        return true
    }
    
    static let triggerTypeKey = "timerTrigger"
    static let typeKey = ""
    
    
    func jsonDescription(direction: BindingDirection) throws -> [String: Any] {
        
        var props: [String: Any] = [
            Definitions.Bindings.Keys.TypeKey: TimerTrigger.triggerTypeKey,
            Definitions.Bindings.Keys.Name: name,
            Definitions.Bindings.Keys.Direction: Definitions.Bindings.DirectionIn,
            Keys.Schedule: schedule
        ]
        
        if let runOnStartVal = runOnStartup {
            props[Keys.RunOnStartup] = runOnStartVal
        }
        
        if let useMonVal = useMonitor {
            props[Keys.UseMonitor] = useMonVal
        }
        
        switch direction {
        case .trigger:
            return props
        default:
            throw FunctionError.internalInconsistancyException("Error generating bidining description")
        }
        
    }
    
    func stringJsonDescription(direction: BindingDirection) throws -> String {
           return  try jsonDescription(direction: direction).toJsonString()
      }
    
}
