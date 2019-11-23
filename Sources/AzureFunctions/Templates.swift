//
//  Templates.swift
//  SwiftFunc
//
//  Created by Saleh on 11/14/19.
//

import Foundation

internal struct Templates {
    
    struct ProjectFiles {
        
        static let functionJson = """
        {{ bindings }}
        """
        
        static let hostJsonDebug = """
        {
            "version": "2.0",
            "extensionBundle": {
                "id": "Microsoft.Azure.Functions.ExtensionBundle",
                "version": "[1.*, 2.0.0)"
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
        
    }
}
