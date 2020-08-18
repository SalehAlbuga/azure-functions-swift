//
//  Templates.swift
//  SwiftFunc
//
//  Created by Saleh on 11/14/19.
//

import Foundation

internal struct Templates {
    
    struct ProjectFiles {
        
        static let defaultExtensionsBundleId = "Microsoft.Azure.Functions.ExtensionBundle"
        static let defaultExtensionsVersion = "[1.*, 2.0.0)"
        static let defaultWorkerExecutablePath = "/home/site/wwwroot/workers/swift/functions"
        static let defaultHandlerExecutablePath = "/home/site/wwwroot/functions"
        
        static let functionJson = """
        {{ bindings }}
        """
        
        static let hostJsonExtensions = """
        {
            "version": "2.0",
            "extensionBundle": {
                "id": "{{ extensionBundleID }}",
                "version": "{{ extensionBundleVersion }}"
            }
        }
        """
        
        static let hostJsonExtensionsHttpWorker = """
        {
            "version": "2.0",
            "extensionBundle": {
                "id": "{{ extensionBundleID }}",
                "version": "{{ extensionBundleVersion }}"
            },
            "httpWorker": {
                "description": {
                    "defaultExecutablePath": "{{ execPath }}",
                     "arguments": [ "run" ]
                }
            }
        }
        """
        
        static let hostJson = """
        {
            "version": "2.0"
        }
        """
        
        static let workerConfigJson = """
        {
            "description": {
                "arguments": [
                    "run"
                ],
                "defaultExecutablePath": "{{ execPath }}",
                "extensions": [
                    ".swift"
                ],
                "language": "swift"
            }
        }
        """
        
        static let localSettingsJson = """
        {
            "IsEncrypted": false,
            "Values": {
                "FUNCTIONS_WORKER_RUNTIME": "swift",
                "languageWorkers:workersDirectory": "workers",
                {{ envVars }}
            }
        }
        """
        
        static let localSettingsJsonHttp = """
       {
           "IsEncrypted": false,
           "Values": {
               {{ envVars }}
           }
       }
       """
        
    }
}
