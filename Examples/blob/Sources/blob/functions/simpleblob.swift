//
//  simpleblob.swift
//  blob
//
//  Created on 26-12-19.
//

import Foundation
import AzureFunctions

class simpleblob: Function {
    
    required init() {
        super.init()
        self.name = "simpleblob"
        self.trigger = Blob(name: "blobTrigger", path: "sample/{filename}", connection: "AzureWebJobsStorage")
    }
    
    override func exec(blob: Blob, context: inout Context, callback: @escaping callback) throws {
        if let data = blob.blob as? Data, let content = String(data: data, encoding: .utf8) {
            context.log("Got file with Content-Type \(blob.properties["ContentType"] ?? ""), content: \(content)")
        }
        
        return callback(true)
    }
    
}
