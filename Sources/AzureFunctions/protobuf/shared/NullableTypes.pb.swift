// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: NullableTypes.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

/// protobuf vscode extension: https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct NullableString {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var string: NullableString.OneOf_String? = nil

  var value: String {
    get {
      if case .value(let v)? = string {return v}
      return String()
    }
    set {string = .value(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_String: Equatable {
    case value(String)

  #if !swift(>=4.1)
    static func ==(lhs: NullableString.OneOf_String, rhs: NullableString.OneOf_String) -> Bool {
      switch (lhs, rhs) {
      case (.value(let l), .value(let r)): return l == r
      }
    }
  #endif
  }

  init() {}
}

struct NullableDouble {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var double: NullableDouble.OneOf_Double? = nil

  var value: Double {
    get {
      if case .value(let v)? = double {return v}
      return 0
    }
    set {double = .value(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Double: Equatable {
    case value(Double)

  #if !swift(>=4.1)
    static func ==(lhs: NullableDouble.OneOf_Double, rhs: NullableDouble.OneOf_Double) -> Bool {
      switch (lhs, rhs) {
      case (.value(let l), .value(let r)): return l == r
      }
    }
  #endif
  }

  init() {}
}

struct NullableBool {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var bool: NullableBool.OneOf_Bool? = nil

  var value: Bool {
    get {
      if case .value(let v)? = bool {return v}
      return false
    }
    set {bool = .value(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Bool: Equatable {
    case value(Bool)

  #if !swift(>=4.1)
    static func ==(lhs: NullableBool.OneOf_Bool, rhs: NullableBool.OneOf_Bool) -> Bool {
      switch (lhs, rhs) {
      case (.value(let l), .value(let r)): return l == r
      }
    }
  #endif
  }

  init() {}
}

struct NullableTimestamp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var timestamp: NullableTimestamp.OneOf_Timestamp? = nil

  var value: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {
      if case .value(let v)? = timestamp {return v}
      return SwiftProtobuf.Google_Protobuf_Timestamp()
    }
    set {timestamp = .value(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Timestamp: Equatable {
    case value(SwiftProtobuf.Google_Protobuf_Timestamp)

  #if !swift(>=4.1)
    static func ==(lhs: NullableTimestamp.OneOf_Timestamp, rhs: NullableTimestamp.OneOf_Timestamp) -> Bool {
      switch (lhs, rhs) {
      case (.value(let l), .value(let r)): return l == r
      }
    }
  #endif
  }

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension NullableString: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "NullableString"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        if self.string != nil {try decoder.handleConflictingOneOf()}
        var v: String?
        try decoder.decodeSingularStringField(value: &v)
        if let v = v {self.string = .value(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if case .value(let v)? = self.string {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: NullableString, rhs: NullableString) -> Bool {
    if lhs.string != rhs.string {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension NullableDouble: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "NullableDouble"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        if self.double != nil {try decoder.handleConflictingOneOf()}
        var v: Double?
        try decoder.decodeSingularDoubleField(value: &v)
        if let v = v {self.double = .value(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if case .value(let v)? = self.double {
      try visitor.visitSingularDoubleField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: NullableDouble, rhs: NullableDouble) -> Bool {
    if lhs.double != rhs.double {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension NullableBool: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "NullableBool"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        if self.bool != nil {try decoder.handleConflictingOneOf()}
        var v: Bool?
        try decoder.decodeSingularBoolField(value: &v)
        if let v = v {self.bool = .value(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if case .value(let v)? = self.bool {
      try visitor.visitSingularBoolField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: NullableBool, rhs: NullableBool) -> Bool {
    if lhs.bool != rhs.bool {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension NullableTimestamp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "NullableTimestamp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        var v: SwiftProtobuf.Google_Protobuf_Timestamp?
        if let current = self.timestamp {
          try decoder.handleConflictingOneOf()
          if case .value(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.timestamp = .value(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if case .value(let v)? = self.timestamp {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: NullableTimestamp, rhs: NullableTimestamp) -> Bool {
    if lhs.timestamp != rhs.timestamp {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
