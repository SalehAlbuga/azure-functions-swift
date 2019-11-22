//
//  CodeGen.swift
//  SwiftFunc
//
//  Created by Saleh on 11/15/19.
//

import Foundation
import Files
import Stencil


internal struct CodeGen {
    
    static func exportScriptRoot(registry: FunctionRegistry,sourceDir: String, rootDir: String, debug: Bool) throws {
        
        guard let srcFolder = try? Folder.init(path: sourceDir), srcFolder.containsFile(at: "Package.swift"), let projectName = try? Folder.init(path: "\(sourceDir)/Sources").subfolders.first?.name else {
            print("Not a Swift Project")
            exit(1)
        }
        
        let environment = Environment()
        
        let rootFolder = try Folder.init(path: rootDir)
        
        
        print("Creating host.json")
        let hostRes: String
        if debug {
            hostRes = try environment.renderTemplate(string: Templates.ProjectFiles.hostJsonDebug, context: nil)
        } else {
            hostRes = try environment.renderTemplate(string: Templates.ProjectFiles.hostJson, context: nil)
        }
        let hostFile = try rootFolder.createFile(named: "host.json")
        try hostFile.write(hostRes)
        
        print("Creating local.settings.json")
        let localSetRes: String
        
        if let storage = registry.AzureWebJobsStorage {
            localSetRes = try environment.renderTemplate(string: Templates.ProjectFiles.localSettingsJson, context: ["envVars": "\"AzureWebJobsStorage\": \"\(storage)\""])
        } else {
             localSetRes = try environment.renderTemplate(string: Templates.ProjectFiles.localSettingsJson, context: nil)
        }
       
        let localSetFile = try rootFolder.createFile(named: "local.settings.json")
        try localSetFile.write(localSetRes)
        
        print("Creating worker.config.json")
        let workersFolder = try rootFolder.createSubfolderIfNeeded(withName: "workers")
        let swiftFolder = try workersFolder.createSubfolderIfNeeded(withName: "swift")
        let workerRes = try environment.renderTemplate(string: Templates.ProjectFiles.workerConfigJson, context: ["execPath": "\(swiftFolder.path)functions"])
        let workerFile = try swiftFolder.createFile(named: "worker.config.json")
        try workerFile.write(workerRes)
        
        #if os(Linux)
        let releaseFolder = "x86_64-unknown-linux"
        #else
        let releaseFolder = "x86_64-apple-macosx"
        #endif
        
        try File.init(path: "\(sourceDir)/.build/\(releaseFolder)/release/functions").copy(to: swiftFolder)
        
        
        for file in try Folder(path: "\(sourceDir)/Sources/\(projectName)/functions").files {
            guard file.extension == "swift" else {
                break
            }
            let name = file.nameExcludingExtension
            print("Exporting \(name)")
            let funcFolder = try rootFolder.createSubfolderIfNeeded(withName: name)
            try file.copy(to: funcFolder)
            
            do {
                if let function = registry.byName(name: name) {
                    let bindings = try function.getFunctionJsonBindings()
                    let workerRes = try environment.renderTemplate(string: Templates.ProjectFiles.functionJson, context: ["bindings": bindings])
                    let workerFile = try funcFolder.createFile(named: "function.json")
                    try workerFile.write(workerRes)
                } else {
                    print("function not found")
                    exit(1)
                }
            } catch {
                print("error generating bindings \(error.localizedDescription)")
                exit(1)
            }
        }
        
        print("Project exported!")
        
    }
}
