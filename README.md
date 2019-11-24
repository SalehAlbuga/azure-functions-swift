# Azure Functions for Swift ⚡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Implementation of [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
in [Swift](https://swift.org).

> **Disclaimer**  
> This project is not an official Azure project.
>
> _Microsoft and Azure are registered trademarks of Microsoft Corporation._

## Example

An HTTP Function:

```swift
import Foundation
import AzureFunctions

class HttpFunction: Function {
    
    required init() {
        super.init()
        self.name = "HttpFunction"
        self.trigger = HttpRequest(name: "req")
    }
    
    override func exec(request: HttpRequest, context: inout Context, callback: @escaping callback) throws {
      
        let res = HttpResponse()
        res.statusCode = 200
        context.log(String(describing: request.query))
        
        var name: String?
        context.log("BODY: \(request.body?.description ?? "Body")")
        
        if let data = request.body, let bodyObj: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? [String: Any] {
            name = bodyObj["name"] as? String
        } else {
            name = request.query["name"]
        }
        res.body  = "Hello \(name ?? "buddy")!".data(using: .utf8)
        
        return callback(res);
    } 
}
```

## Getting Started

## Installation

### Requirements

#### macOS 10.13 or later

#### Xcode 11/Swift 5

#### .NET Core SDK

.NET Core is required to for Azure Functions Host binding extensions like Blob, etc.

Download .Net Core from [here](https://dotnet.microsoft.com/download/dotnet-core/2.2)

#### Azure Functions Core Tools

Install the latest [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools).

#### Swift Functions Tools

Just like Core Tools, Swift Functions Tools make functions development easier and helps in initializing the project and running the Functions locally.

```bash
$ brew tap salehalbuga/formulae
$ brew install swift-func
```

This installs a CLI tool called `swiftfunc` that can be used to create and run new Azure Functions.

## Creating a new Azure Functions app

Run `swiftfunc init myApp` command to create a new Azure Functions application:

``` bash
swiftfunc init myApp
```

It will create a new app in a new folder, and a folder named `functions` inside the Sources target where Functions should be

## Creating a sample HTTP functions

Inside the new directory of your project, run `swiftfunc new http --name hello` command to create a new HTTP Function named `hello`:

``` bash
swiftfunc new http --name hello
```

The new function file will be created inside `Sources/myApp/functions/hello.swift`.

## Running the new Functions App

Run `swiftfunc run` in the project directory to run your Swift Functions project locally. It will compile the code and start the host for you

> More docs coming soon!
