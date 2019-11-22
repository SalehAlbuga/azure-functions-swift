//
//  Logger.swift
//  SwiftFunc
//
//  Created by Saleh on 9/6/19.
//

import Foundation

internal struct Logger {
    
    static let LogPrefix: String = "LanguageWorkerConsoleLog"
    
    static func log(_ message: String) {
        print("\(LogPrefix) \(message)")
    }
    
    static func logError(message: String) {
        print("\(LogPrefix) [ERROR] \(message)")
    }
}
