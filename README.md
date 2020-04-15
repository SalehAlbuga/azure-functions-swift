# Azure Functions for Swift ⚡️

[![ver](https://img.shields.io/github/v/release/salehalbuga/azure-functions-swift?include_prereleases&label=version)](https://swiftfunc.developerhub.io)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 


Write [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
in [Swift](https://swift.org).

> **Disclaimer**  
> This project is not an official Azure project.
>
> _Microsoft and Azure are registered trademarks of Microsoft Corporation._

#### Documentation [home page](https://swiftfunc.developerhub.io/) 

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
        var name: String?
        
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
Currently the Swift Functions Tools are only supported on macOS. *(although, you can develop Swift Azure Functions on Linux but running them locally requires a lot of manual work).*

#### Swift 5/Xcode 11 or later

#### .NET Core SDK

.NET Core is required to for Azure Functions Host binding extensions like Blob, etc.

You can download .Net Core SDK from [here](https://dotnet.microsoft.com/download/dotnet-core/2.2)

#### Azure Functions Core Tools

Install the latest [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools).

#### Swift Functions Tools

Just like Core Tools, Swift Functions Tools make functions development easier and helps in initializing the project and running the Functions locally. 

You can install it from [Homebrew](https://brew.sh) 🍺
```bash
brew install salehalbuga/formulae/swift-func
```

It installs a CLI tool called `swiftfunc` that can be used to create, projects, functions and run Swift Azure Functions projects.

## Developing Azure Functions in Swift
## Creating a new Project/Azure Functions app

Run `swiftfunc init myApp` command to create a new Azure Functions application:

``` bash
swiftfunc init myApp
```

It will create a new app in a new folder, and a folder named `functions` inside the Sources target where Functions should be (*/myApp/Sources/myApp/functions*).
The project created is a Swift package project with the Azure Functions framework dependency.

Optionally, you can generate an Xcode project using SwiftPM for easier development.
```bash
swift package generate-xcodeproj
```

## Creating a simple HTTP function

Inside the new directory of your project, run `swiftfunc new http --name hello` command to create a new HTTP Function named `hello`:

``` bash
swiftfunc new http --name hello
```

The new function file will be created in the following path `Sources/myApp/functions/hello.swift`.

## Running the new Functions App
Run `swiftfunc run` in the project directory to run your Swift Functions project locally. It will compile the code and start the host for you *(as if you were running `func host start`)*. The host output should show you the URL of `hello` function created above. Click on it to run the function and see output!

## Deploying to Azure 

Curently Swift Functions Tools do not provide a command to deploy to Azure. To deploy the Function App to Azure, you'll need to build the provided docker image, push to a registry and set it in the Container Settings of the Function App.

Build the image
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

## Bindings
Azure Functions offer a variety of [Bindings and Triggers](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings)

Currently the following are supported by Swift Functions. More bindings will be implemented and many improvements will be in the near future.

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

Currently, tThe trigger, inputs and output of a Function are set in its constructor. Azure Functions in Swift must inherit the **Function** class from the framework.

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
#### Framework updates
As the framework is being actively updated, update the framework and the tools if you're having any issues or want to have the latest features and improvements.

To update the framework:
```bash
swift package update
```

To update the tools:
```bash
brew upgrade salehalbuga/formulae/swift-func
```

### Storage Connections
In the generated `main.swift` you can define your debug `AzureWebJobsStorage` and optionally any other connections/environment vars.

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

registry.register(hello.self) 
...
```

Be sure not to commit any debugging Storage Account keys to a repo

### Logging
You can log using the log method in `context` object
```swift
context.log(_) 
``` 

### Execution
When your Function is done executing the logic you should call the provided callback passing the [`$return`](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-return-value?tabs=csharp) output binding value or with `true` if none.
```swift
callback(res)
```

>The framework is still in an early stage, was tested in the basic supported bindings. Many improvements will be made.
>Pipeline:
>Better Documentation.
>Sample Functions.
>Finalize and publish the tests.
>Support more bindings.

