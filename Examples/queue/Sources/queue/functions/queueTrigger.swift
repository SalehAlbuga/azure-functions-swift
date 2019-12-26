//
//  queueTrigger.swift
//  queue
//
//  Created on 08-12-19.
//

import Foundation
import AzureFunctions

class queueTrigger: Function {

    required init() {
        super.init()
        self.name = "queueTrigger"
        self.trigger = Queue(name: "myQueueTrigger", queueName: "queueName", connection: "AzureWebJobsStorage")
    }

    override func exec(string: String, context: inout Context, callback: @escaping callback) throws {
        context.log("Got queue item: \(string)")
        callback(true)
    }
}