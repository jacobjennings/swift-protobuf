// Sources/SwiftProtobuf/ExtensionFieldValueSet.swift - Extension support
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
///
/// A collection of extension field values on a particular object.
/// This is only used within messages to manage the values of extension fields;
/// it does not need to be very sophisticated.
///
// -----------------------------------------------------------------------------

import Swift

public struct ExtensionFieldValueSet: Equatable, Sequence {
    public typealias Iterator = Dictionary<Int, AnyExtensionField>.Iterator
    fileprivate var values = [Int : AnyExtensionField]()
    public init() {}

    public func makeIterator() -> Iterator {
        return values.makeIterator()
    }

    public var hashValue: Int {
        var hash: Int = 0
        for i in values.keys.sorted() {
            hash = (hash &* 16777619) ^ values[i]!.hashValue
        }
        return hash
    }

    public func traverse(visitor: inout Visitor, start: Int, end: Int) throws {
        let validIndexes = values.keys.filter {$0 >= start && $0 < end}
        for i in validIndexes.sorted() {
            let value = values[i]!
            try value.traverse(visitor: &visitor)
        }
    }

    public subscript(index: Int) -> AnyExtensionField? {
        get {return values[index]}
        set(newValue) {values[index] = newValue}
    }

    public func fieldNames(for number: Int) -> FieldNameMap.Names? {
        return values[number]?.protobufExtension.fieldNames
    }
}

public func ==(lhs: ExtensionFieldValueSet, rhs: ExtensionFieldValueSet) -> Bool {
    for (index, l) in lhs.values {
        if let r = rhs.values[index] {
            if type(of: l) != type(of: r) {
                return false
            }
            if !l.isEqual(other: r) {
                return false
            }
        } else {
            return false
        }
    }
    for (index, _) in rhs.values {
        if lhs.values[index] == nil {
            return false
        }
    }
    return true
}
