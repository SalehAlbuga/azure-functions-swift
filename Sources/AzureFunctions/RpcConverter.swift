//
//  RpcConverter.swift
//  SwiftFunc
//
//  Created by Saleh on 10/5/19.
//

import Foundation

internal final class RpcConverter {
    
    static func toRpcTypedData(obj: Any) -> AzureFunctionsRpcMessages_TypedData {
        var td = AzureFunctionsRpcMessages_TypedData()
        //        Logger.log(message: obj)
        switch obj {
        case let string as String:
            if string.starts(with: "{") || string.starts(with: "[") { // TODO detect JSON in str
                td.json = string
            } else {
                td.string = string
            }
            break
        case let dic as [String:Any]:
            td.json = dic.description
            break
        case let data as Data:
            td.bytes = data
            break
        case let int as Int:
            td.int = Int64(int)
            break
        case let double as Double:
            td.double = double
            break
        case let httpRes as HttpResponse:
            td.http = httpRes.toRpcHttp()
            break
        case let dataArr as [Data]:
            var col = AzureFunctionsRpcMessages_CollectionBytes()
            col.bytes = dataArr
            td.collectionBytes = col
            break
        case let strArr as [String]:
            var col = AzureFunctionsRpcMessages_CollectionString()
            col.string = strArr
            td.collectionString = col
            break
        case let intArr as [Int64]:
            var col = AzureFunctionsRpcMessages_CollectionSInt64()
            col.sint64 = intArr
            td.collectionSint64 = col
            break
        case let dblArr as [Double]:
            var col = AzureFunctionsRpcMessages_CollectionDouble()
            col.double = dblArr
            td.collectionDouble = col
            break
        default:
            Logger.log("Unsupported data type by worker!")
            td.string = "Unsupported data type by worker!"
            break
        }
        return td
    }
    
    static func fromTypedData(data: AzureFunctionsRpcMessages_TypedData, preferJsonInString: Bool = false) throws -> Any?  {
        var converted: Any?
        
        switch data.data {
        case let .some(.http(http)):
            let httpReq = HttpRequest(fromRpcHttp: http)
            converted = httpReq
            break
        case let .some(.json(jsonStr)):
            if let data = jsonStr.data(using: .utf8) {
                do {
                    converted = try JSONSerialization.jsonObject(with: data, options: [])
                    //                    if jsonStr.starts(with: "[") {
                    //                        converted = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    //                    } else {
                    //                        converted = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    //                    }
                } catch {
                    Logger.log(error.localizedDescription)  // throw exception
                    throw FunctionError.JSONSerializationException(error.localizedDescription)
                }
            } else {
                throw FunctionError.JSONSerializationException("Cannot deserialize JSON")
            }
            break
        case let .some(.bytes(data)):
            converted = data
            break
        case let .some(.stream(data)):
            converted = data
            break
        case let .some(.string(string)):
            if !preferJsonInString {
                converted = string
            } else {
                if let data = string.data(using: .utf8) {
                    if string.starts(with: "[") {
                        converted = (try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]) ?? string
                    } else {
                        converted = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]) ?? string
                    }
                } else {
                    converted = string
                }
            }
            break
        case let .some(.double(double)):
            converted = double
            break
        case let .some(.int(int)):
            converted = int
            break
        case let .some(.collectionBytes(colBytes)):
            converted = colBytes.bytes
            break
        case let .some(.collectionDouble(colDouble)):
            converted = colDouble.double
            break
        case let .some(.collectionSint64(colInt)):
            converted = colInt.sint64
            break
        case let .some(.collectionString(colStr)):
            converted = colStr.string
            break
        default:
            Logger.log("Unsupported data type by worker!")
            converted = "Unsupported data type by worker!"
            break
        }
        
        return converted
    }
    
    
    static func fromBodyTypedData(data: AzureFunctionsRpcMessages_TypedData) -> Data?  {
        var converted: Data? = nil
        
        switch data.data {
        case let .some(.stream(data)):
            converted = data
            break
        case let .some(.bytes(data)):
            converted = data
            break
        case let .some(.json(str)), let .some(.string(str)):
            if let data = str.data(using: .utf8) {
                converted = data
                break
            }
        default:
            break
        }
        return converted
    }
    
}
