# Azure Functions for Swift ⚡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Write [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
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

#### Xcode 11/Swift 5 or later

#### .NET Core SDK

.NET Core is required to for Azure Functions Host binding extensions like Blob, etc.

Download .Net Core from [here](https://dotnet.microsoft.com/download/dotnet-core/2.2)

#### Azure Functions Core Tools

Install the latest [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools).

#### Swift Functions Tools

Just like Core Tools, Swift Functions Tools make functions development easier and helps in initializing the project and running the Functions locally.

```bash
$ brew install salehalbuga/formulae/swift-func
```

This installs a CLI tool called `swiftfunc` that can be used to create and run Swift Azure Functions projects.

## Creating a new Azure Functions app

Run `swiftfunc init myApp` command to create a new Azure Functions application:

``` bash
swiftfunc init myApp
```

It will create a new app in a new folder, and a folder named `functions` inside the Sources target where Functions should be (*/myApp/Sources/myApp/functions*).
The project created is a Swift package project with the Azure Functions framework dependency.

After that you can generate an Xcode project using SwiftPM for easier development.
```bash
swift package generate-xcodeproj
```

## Creating a sample HTTP function

Inside the new directory of your project, run `swiftfunc new http --name hello` command to create a new HTTP Function named `hello`:

``` bash
swiftfunc new http --name hello
```

The new function file will be created inside `Sources/myApp/functions/hello.swift`.

## Running the new Functions App
Run `swiftfunc run` in the project directory to run your Swift Functions project locally. It will compile the code and start the host for you *(as if you were running `func host start`)*. The host output should show you the URL of `hello` function created above. Click on it to run the function and see output!

## Deploying to Azure 

Curently Swift Functions Tools do not provide commad to deploy to Azure. To deploy the Function App to Azure, you'll need to build the provided docker image, push to a registry and set it in the Container Settings of the Function App.
To build the image:
```bash
docker build -t <imageTag> .
```
If you're using DockerHub then the tag would be `username/imageName:version`. 
If you're using ACR ([Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)) or any other private registry the tag would be `registryURL/imageName:version`

Then push it the built image
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
| Blob     | Input and Ouput Blob                | in, out |
| Blob     | Blob Trigger                        | in      | 
| HttpRequest | HTTP Trigger                     | in             | 
| HttpResponse| Output HTTP Response             | out            | 
| Message datatype **String** or **Data** (defined by Queue) | Output Queue Message                | out            | 
| Message datatype **String** or **Data** (defined by Queue)      | Queue Trigger                       | in             | 
| ServiceBusMessage | Service Bus Output Message          | out            | 
| ServiceBusMessage | Service Bus Trigger                 | in             | 
| Message datatype **String** or **Data** (defined by Table)             | Input and Ouput Table               | in, out        | 
| TimerTrigger | Timer Trigger                       | in             | 



Unlike C#, Swift does not support Attributes to mark bindings types and directions. Alternatively, the trigger, inputs and output of a Function is set in its constructor. Azure Functions in Swift must inhert the **Function** class from the framework.

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

>The framework is still in an early stage, was tested in most supported bindings. Many improvements will be made.

