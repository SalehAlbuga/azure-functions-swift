//
//  Broker.swift
//  SwiftFunc
//
//  Created by Saleh on 10/5/19.
//

import Foundation

internal class Broker {
    
    static func run(function: Function, input: Any?, context: inout Context, callback: @escaping callback) throws {
        
        // handle empty input!!

        guard let inputBinding = input else {
            throw FunctionError.internalInconsistancyException("Cannot determin Function Input")
        }
        
            switch inputBinding {
            case let http as HttpRequest:
                try function.exec(request: http, context: &context, callback: callback)
                break
            case let timer as TimerTrigger:
                try function.exec(timer: timer, context: &context, callback: callback)
                break
            case let blob as Blob:
                try function.exec(blob: blob, context: &context, callback: callback)
                break
            case let data as Data:
                try function.exec(data: data, context: &context, callback: callback)
                break
            case let string as String:
                try function.exec(string: string, context: &context, callback: callback)
                break
            case let dic as [String:Any]:
                try! function.exec(dictionary: dic, context: &context, callback: callback)
                break
            default:
                throw FunctionError.internalInconsistancyException("Function Input type cannot be determined")
            }
    }
}
