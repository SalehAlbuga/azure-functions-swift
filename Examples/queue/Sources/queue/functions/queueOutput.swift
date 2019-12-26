//
//  queueOutput.swift
//  queue
//
//  Created on 08-12-19.
//

import Foundation
import AzureFunctions

class queueOutput: Function {

    required init() {
        super.init()
        self.name = "queueOutput"
        self.trigger = Queue(name: "myQueueTrigger", queueName: "queueName", connection: "AzureWebJobsStorage")
        self.outputBindings = [Queue(name: "queueOutput", queueName: "outQueueName", connection: "AzureWebJobsStorage")]
    }

    override func exec(string: String, context: inout Context, callback: @escaping callback) throws {
        context.log("Got queue item: \(string), writing to output queue!")
        context.outputBindings["queueOutput"] = string
        callback(true)
    }
}