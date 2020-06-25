//
//  simple.swift
//  servicebus
//
//  Created on 08-12-19.
//

import Foundation
import AzureFunctions

class simple: Function {
    
    required init() {
        super.init()
        self.name = "simple"
        self.trigger = ServiceBusMessage(name: "sbTrigger", topicName: "mytopic", subscriptionName: "mysubscription", connection: "ServiceBusConnection")
    }

    override func exec(sbMessage: ServiceBusMessage, context: inout Context, callback: @escaping callback) throws {
        if let msg: String = sbMessage.message as? String {
            context.log("Got topic message: \(msg)")
        } 

        callback(true)
    }
}