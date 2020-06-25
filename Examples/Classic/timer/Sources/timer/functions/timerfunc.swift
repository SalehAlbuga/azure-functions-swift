//
//  timerfunc.swift
//  timer
//
//  Created on 26-12-19.
//

import Foundation
import AzureFunctions

class timerfunc: Function {
    
    required init() {
        super.init()
        self.name = "timerfunc"
        self.trigger = TimerTrigger(name: "myTimer", schedule: "*/5 * * * * *")
    }
    
    override func exec(timer: TimerTrigger, context: inout Context, callback: @escaping callback) throws {
        context.log("It is time!")
        callback(true)
    }
    
}