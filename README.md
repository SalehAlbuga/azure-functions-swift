# Azure Functions for Swift ⚡️

[![ver](https://img.shields.io/github/v/release/salehalbuga/azure-functions-swift?include_prereleases&label=version)](https://swiftfunc.developerhub.io)
[![cliver](https://img.shields.io/github/v/release/salehalbuga/azure-functions-swift-tools?include_prereleases&label=CLI+version)](https://github.com/SalehAlbuga/azure-functions-swift-tools)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![docs-status](https://img.shields.io/badge/read_the-docs-2196f3.svg)](https://docs.swiftfunc.dev/)
[![Swift version](https://img.shields.io/badge/swift-5.2-brightgreen.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Chat](https://img.shields.io/discord/713477339463418016?label=Join%20Azure%20Functions%20Chat)](http://discord.gg/6rDzSuM)


Write [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
in [Swift](https://swift.org).

#### This framework supports the new Azure Functions [Custom Handlers](https://docs.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers) (starting from 0.6.0) in addition to the traditional custom worker. 

> _Disclaimer: This is a community open source project, not an official Azure project_

#### [Documentation](https://docs.swiftfunc.dev/) 

Deploy a sample project to Azure!

Classic worker sample:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](http://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgist.githubusercontent.com%2FSalehAlbuga%2Fb0d9eeaae04cc07faf95f11b01143e40%2Fraw%2Ff70a0896960d5d6d04ce3bcd5de06a3fed2d8c0b%2Fswiftfunc-classic-sample-arm.json)

Custom Handler sample:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgist.githubusercontent.com%2FSalehAlbuga%2Fc937140075effe782996f12961b3f46d%2Fraw%2Fd94eb814fbb2250908e242aafea650576d620833%2Fswiftfunc-sample-arm.json)


## Examples

A Timer Function (Custom Handler):

```swift
import Foundation
import AzureFunctions
import Vapor

class TimerFunction: Function {
    
    required init() {
        super.init()
        self.name = "TimerFunction"
        self.functionJsonBindings =
            [
                [
                "type" : "timerTrigger",
                "name" : "myTimer",
                "direction" : "in",
                "schedule" : "*/5 * * * * *"
                ]
            ]
        //or
        //self.trigger = TimerTrigger(name: "myTimer", schedule: "*/5 * * * * *")

        app.post([PathComponent(stringLiteral: name)], use: run(req:))
    }

    func run(req: Request) -> InvocationResponse {
        var res = InvocationResponse()
        res.appendLog("Its is time!")
        return res
    }
}
```

An HTTP Function (Classic Worker):
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
```

## Getting Started

### Installation and Requirements

#### **Swift 5.2 or later or Xcode 11 or later on macOS**

Swift installation: https://swift.org/getting-started/#installing-swift

#### **Azure Functions Core Tools**

Install the latest [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools).

#### **Swift Functions Tools**

Just like Core Tools, Swift Functions Tools make Swift functions development easier and much more convenient.

On **macOS**, you can install it from [Homebrew](https://brew.sh) 🍺
```bash
brew install salehalbuga/formulae/swift-func
```

on **Linux**, 

Clone the repo the tools repo
```bash
git clone https://github.com/SalehAlbuga/azure-functions-swift-tools
```

Install
```bash
make install
```

It installs a CLI tool called `swiftfunc` that can be used to create projects, functions and run them locally.

### Creating a new Project/Azure Functions app

Run the init command to create a new Azure Functions application:

``` bash
swiftfunc init myApp [-hw]
```

It will create a new app in a new folder, and a folder named `functions` inside the Sources target where Functions should be (*/myApp/Sources/myApp/functions*).
The project created is a Swift package project with the Azure Functions framework dependency.

Pass `-hw` or `--http-worker` option to create the project with the  [Custom Handler](https://docs.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers) template.

### Creating a simple HTTP function

Inside the new directory of your project, run the following to create a new HTTP Function named `hello`:

``` bash
swiftfunc new http -n hello [-hw]
```

The new function file will be created in the following path `Sources/myApp/functions/hello.swift`.

Similar to the `init` command, pass `-hw` or `--http-worker` option to create the new function with the Custom Handler template.


### Running the new Functions App
Run `swiftfunc run` in the project directory to run your Swift Functions project locally. It will compile the code and start the host for you *(as if you were running `func host start`)*. The host output should show you the URL of `hello` function created above. Click on it to run the function and see output!

## **Deploying to Azure ☁️** 

There are 2 methods to deploy Swift Functions to Azure

### Container Functions

To deploy the Function App in a Container, you can either use the Functions Core Tool `func deploy` command, where it will build the image, push it to a registry and set it in the destination Function App or you can do that manually as shown below.

Build the image (Dockerfile is provided when the project is created)
```bash
docker build -t <imageTag> .
```
If you're using DockerHub then the tag would be `username/imageName:version`. 
If you're using ACR ([Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)) or any other private registry the tag would be `registryURL/imageName:version`

Then push it
```bash
docker push <imageTag>
```

In [Azure portal](https://portal.azure.com), create a new Function App with **Docker Container** as the Publish option. Under Hosting options make sure Linux is selected as OS.

Once the app is created or in any existing Container Function App, under **Platform Features**, select **Container settings** and set the registry and select image you pushed.

You can use the buttons below to deploy prebuilt sample project to your Azure subscription

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](http://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgist.githubusercontent.com%2FSalehAlbuga%2Fb0d9eeaae04cc07faf95f11b01143e40%2Fraw%2Ff70a0896960d5d6d04ce3bcd5de06a3fed2d8c0b%2Fswiftfunc-classic-sample-arm.json)

Custom Handler sample:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgist.githubusercontent.com%2FSalehAlbuga%2Fc937140075effe782996f12961b3f46d%2Fraw%2Fd94eb814fbb2250908e242aafea650576d620833%2Fswiftfunc-sample-arm.json)

### Hosting on a Linux Consumption Plan

First, you need to set the following App Setting in the Function App on Azure.
`LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/site/wwwroot/workers/swift/lib/`

Then depending if you're developing on a Linux machine or a Mac:

#### Linux

Login to your Azure account from Azure CLI
```bash
az login
```

When Azure CLI finishes loading your subscription(s) info, run:
```bash
swiftfunc publish myswiftfunctions
```

Swift Function Tools publish command is going to compile, export and publish your Swift Functions project.

#### macOS

Publishing to a Function App in a Linux Consumption Plan from macOS requires the app to be build in a Linux container first, to do that you can use VSCode Dev Containers.
The project needs to be created with the `-dc` or `--dev-container` option to have the Swift Function Dev Container added (or you can create a new one and copy the .devcontainer folder to your project).
`swiftfunc init myFunctionApp -hw -dc`

Reopen the folder in dev container (Command-Shift-P, search for and select _Remote-Containers: Reopen in Container_)

Once the dev container is ready, follow the same Linux steps above to publish the app! 

## **Bindings**
Azure Functions offer a variety of [Bindings and Triggers](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings)

The trigger, input bindings and output bindings of a Function are set in its initializer. Azure Functions in Swift must subclass the **Function** class from the framework.

### Custom Handler (HTTP Worker)

When using the Custom Handler mode you can use all Azure Functions bindings and triggers by setting the `functionJsonBindings` property to the JSON config of the bindings/triggers in Azure Functions [docs](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings#supported-bindings). You can also use the framework supported Trigger/Binding types listed below.

### Traditional Worker (Classic)

Currently the following are supported by this mode. More bindings will be implemented and many improvements will be made in the future.

| Swift Type                                                                                                                              | Azure Functions Binding             | Direction      |
|----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|----------------|
| HttpRequest | HTTP Trigger                     | in             | 
| HttpResponse| Output HTTP Response             | out            | 
| TimerTrigger | Timer Trigger                       | in             | 
| Message datatype **String** (binding defined by Table in constructor)             | Input and Ouput Table               | in, out        | 
| Message datatype **String** (binding defined by Queue in constructor) | Output Queue Message                | out            | 
| Message datatype **String** (binding defined by Queue in constructor)      | Queue Trigger                       | in             | 
| Blob (the blob data prob is either String or Data)     | Input Blob                | in |
| String or Data     | Output Blob                | out |
| Blob     | Blob Trigger                        | in      | 
| ServiceBusMessage | Service Bus Output Message          | out            | 
| ServiceBusMessage | Service Bus Trigger                 | in             | 

### Custom Handler (HTTP Worker)

```swift
import AzureFunctions
import Vapor

class QueueFunction: Function {

    required init() {
        super.init()
        self.name = "QueueFunction"
        self.functionJsonBindings = [
                [
                    "connection" : "AzureWebJobsStorage",
                    "type" : "queueTrigger",
                    "name" : "myQueueTrigger",
                    "queueName" : "myqueue",
                    "direction" : "in"
                ]
            ]
        // or
        //self.trigger = Queue(name: "myQueueTrigger", queueName: "myqueue", connection: "AzureWebJobsStorage")
        
        app.post([PathComponent(stringLiteral: name)], use: run(req:))
    }
    
    func run(req: Request) -> InvocationResponse {
        ...
```

### Traditional Worker (Classic)

```swift
import AzureFunctions

class HttpFunction: Function {
    
    required init() {
        super.init()
        self.name = "HttpFunction"
        self.trigger = HttpRequest(name: "req")
        self.inputBindings = [Blob(name: "fileInput", path: "container/myBlob.json", connection: "AzureWebJobsStorage")]
        self.outputBindings = [Queue(name: "queueOutput", queueName: "myQueue", connection: "AzureWebJobsStorage")]
    }
    
    override func exec(request: HttpRequest, context: inout Context, callback: @escaping callback) throws {
   ...
```

## Writing Swift Functions

### Traditional Worker (Classic)

Based on your Function's trigger type the worker will call the appropriate `exec` overload. For instance, if the Function is timer-triggered, then the worker will call
```swift
exec(timer:context:callback:)
```
If it was an HTTP-triggered one:
```swift
exec(request:context:callback:)
```
You can see the list of available overloads in Xcode.

Input and Output bindings are available in the context as Dictionaries, where you can access/set the values using the binding names specified in the constructor.
For example:
```swift
let tableVal = context.inputBindings["myTableInput"]
```

```swift
context.outputBindings["myQueueOutput"] = "new item!"
```

### Custom Handler (HTTP Worker)

The framework uses Vapor 4.0 HTTP server. The `Function` class has the `app` property, thats the Vapor app instance you can use to register your functions's HTTP route.

```swift
class myFunction: Function {
    
    required init() {
        super.init()
        self.name = "myFunction"
        self.functionJsonBindings = [
            [
                "connection" : "AzureWebJobsStorage",
                "type" : "queueTrigger",
                "name" : "myQueueTrigger",
                "queueName" : "myqueue",
                "direction" : "in"
            ]
        ]
        
        app.post([PathComponent(stringLiteral: name)], use: run(req:))
    }
    
    func run(req: Request) -> InvocationResponse {
        var res = InvocationResponse()
        if let payload = try? req.content.decode(InvocationRequest.self) {
            res.appendLog("Got \\(payload.Data?["myQueueTrigger"] ?? "")")
        }
        return res
    }
}
```

The framework also provides the function invocation Request and Response models needed for Azure Function host, which conform to Content protocol from Vapor, along with helper methods.

**Invocation Request:**

```swift
/// Trigger/Bindings data (values).
var data: [String:AnyCodable]?
/// Trigger/Bindings metadata.
var metadata: [String:AnyCodable]?
```

**Invocation Request:**
```swift
/// Output bindings values dictionary
var outputs: [String:AnyCodable]?
/// Functions logs array. These will be logged when the Function is executed
var logs: [String] = []
/// The $return binding value
var returnValue: AnyCodable?
```

#### Framework Updates
As the framework is being actively updated, update the framework and the tools if you're having any issues or want to have the latest features and improvements.

To update the framework:

```bash
swift package update
```

To update the tools on **macOS**
```bash
brew upgrade salehalbuga/formulae/swift-func
```

on **Linux**
```bash
git clone https://github.com/SalehAlbuga/azure-functions-swift-tools
make install
```

### Storage Connections and other settings
In the generated `main.swift` you can define your debug `AzureWebJobsStorage` and optionally any other connections/environment vars.
Additionally, you can change the default Extension Bundle id and version.

```swift
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

registry.AzureWebJobsStorage = "yourConnection" //Remove before deploying. Do not commit or push any Storage Account keys
registry.EnvironmentVariables = ["queueStorageConnection": "otherConnection"]

// Optionally you can change the default ExtensionBundleId and version 
registry.ExtensionBundleId = "Microsoft.Azure.Functions.ExtensionBundle"
registry.ExtensionBundleVersion = "[1.*, 2.0.0)"

registry.register(hello.self)
...
```

Be sure not to commit any debugging Storage Account keys to a repo

### Logging

**Traditional Worker (Classic)**

You can log using the log method in `context` object
```swift
context.log(_)
```

**Custom Handler (HTTP Worker)**

Logs are returned in the InvocationResponse obj. You can append logs:
```swift
res.appendLog(_)
```

### Code Execution Note
**Traditional Worker (Classic)**

When your Function is done executing the logic you should call the provided callback passing the [`$return`](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-return-value?tabs=csharp) output binding value or with `true` if none.

```swift
callback(res)
```
