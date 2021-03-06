// ProtobufRuntime/Sources/Protobuf/ProtoNameProviding.swift - Resolve proto field names
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
// -----------------------------------------------------------------------------


/// This type contains helper functions to resolve field names based on their
/// numbers during encoding.
///
/// This type is public since it might be useful to clients who want to write
/// advanced custom visitors.
public enum ProtoNameResolvers {

  /// Returns a function that resolves the proto/text name for fields defined on
  /// the given message or in any set extensions.
  ///
  /// If the name cannot be resolved (because the field number is not defined
  /// on the message or any of its extensions, or names were not compiled into
  /// the binary), then the resolver returns nil.
  public static func protoFieldNameResolver(
    for message: Message
  ) -> (Int) -> String? {
    if let nameProviding = message as? ProtoNameProviding {
      return { number in
        nameProviding._protobuf_fieldNames(for: number)?.protoName
      }
    } else {
      return { _ in nil }
    }
  }

  /// Returns a function that resolves the JSON name for fields defined on the
  /// given message or in any set extensions.
  ///
  /// If the name cannot be resolved (because the field number is not defined
  /// on the message or any of its extensions, or names were not compiled into
  /// the binary), then the resolver returns nil.
  public static func jsonFieldNameResolver(
    for message: Message
  ) -> (Int) -> String? {
    if let nameProviding = message as? ProtoNameProviding {
      return { number in
        nameProviding._protobuf_fieldNames(for: number)?.jsonName
      }
    } else {
      return { _ in nil }
    }
  }

  /// Returns a function that resolves the Swift property name for fields
  /// defined on the given message or in any set extensions.
  ///
  /// If the name cannot be resolved (because the field number is not defined
  /// on the message or any of its extensions, or names were not compiled into
  /// the binary), then the resolver returns nil.
  public static func swiftFieldNameResolver(
    for message: Message
  ) -> (Int) -> String? {
    if let nameProviding = message as? ProtoNameProviding {
      return { number in
        nameProviding._protobuf_fieldNames(for: number)?.swiftName
      }
    } else {
      return { _ in nil }
    }
  }
}
