//
//  main.swift
//  
//
//  Auto Generated by SwiftFunctionsSDK
//
//  Only set env vars or register/remove Functions. Do Not modify/add other code
//

import AzureFunctions

let registry = FunctionRegistry()

// ****** optional: set debug AzureWebJobsStorage or other vars ******
registry.AzureWebJobsStorage = "DefaultEndpointsProtocol=https;AccountName=linuxappstorage;AccountKey=2LhvsBsrVxef2AgxY87ByNhdYDjm9Ehl70Mu6W97vw3aYS5mvnwfhUiiaqhG+w/B4meuaEfiZTWJm2Z1TeuFsQ==;EndpointSuffix=core.windows.net" //Remove before deploying. Do not commit or push any Storage Account keys
//registry.EnvironmentVariables = ["fooConnection": "bar"]

// ******

registry.register(simpleblob.self) 


AzureFunctionsWorker.shared.main(registry: registry)