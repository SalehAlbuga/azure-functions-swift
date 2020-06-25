//
//  simpleHttp.swift
//  http
//
//  Created on 08-12-19.
//

import Foundation
import AzureFunctions

class simpleHttp: Function {
    
    required init() {
        super.init()
        self.name = "simpleHttp"
        self.trigger = HttpRequest(name: "req", methods: ["GET", "POST"])
    }
    
    override func exec(request: HttpRequest, context: inout Context, callback: @escaping callback) throws {
        
        context.log("Function executing!")

        let res = HttpResponse()
        var name: String?
        
        if let data = request.body, let bodyObj: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            name = bodyObj["name"] as? String
        } else {
            name = request.query["name"] 
        }
        res.body  = "Hello \(name ?? "buddy")!".data(using: .utf8)
        
        return callback(res);
    }
}