//
//  JSONObjectType.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 19/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Protocols
public protocol JSONType {
    var bool: Bool? { get }
    var int: Int? { get }
    var double: Double? { get }
    var string: String? { get }
    var array: [Self]? { get }
    var dictionary: [String: Self]? { get }
    
    init(bool: Bool)
    init(int: Int)
    init(double: Double)
    init(string: String)
    init(array: [Self])
    init(dictionary: [String: Self])
    
    func value() throws -> Bool
    func value() throws -> Int
    func value() throws -> Double
    func value() throws -> String
    func arrayValue() throws -> [Self]
    func dictionaryValue() throws -> [String: Self]
}

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONRepresentable {
    var jsonValue: JSON { get }
}

public protocol PropertiesContaining {
    associatedtype PropertyKey: RawRepresentable, Hashable
}

public protocol JSONObjectInitializable: PropertiesContaining, JSONInitializable {
    init(object: JSONObject<PropertyKey>) throws
}

public protocol JSONObjectRepresentable: PropertiesContaining, JSONRepresentable {
    var dictValue: [PropertyKey: JSONRepresentable?] { get }
}

public protocol JSONModelType: JSONObjectInitializable, JSONObjectRepresentable {}


// MARK: - JSONInitializable extensions
extension JSON: JSONInitializable, JSONRepresentable {
    public init(json: JSON) { self = json }
    public var jsonValue: JSON { return self }
}

extension String: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(string: self) }
}

extension Bool: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(bool: self) }
}

extension Int: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(int: self) }
}

extension Double: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(double: self) }
}


// MARK: - Handy extensions
struct JSONArray<T: JSONRepresentable>: JSONRepresentable {
    let array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
    
    var jsonValue: JSON {
        return JSON(array.map({ $0.jsonValue }))
    }
}

public extension Array where Element: JSONRepresentable {
    public var jsonRepresantable: JSONRepresentable {
        return JSONArray<Element>(self)
    }
}

public extension Array where Element: JSONInitializable {
    public init(json: JSON) throws {
        self = try json.arrayValue().lazy.enumerated().map({ index, json in
            do {
                return try Element(json: json)
            } catch let error as JSONModelError {
                throw JSONModelError.invalidValueFor(key: String(index), error)
            }
        })
    }
}

struct JSONDict<T: JSONRepresentable>: JSONRepresentable {
    let dict: [String: T]
    
    init(_ dict: [String: T]) {
        self.dict = dict
    }
    
    var jsonValue: JSON {
        return JSON(dict.mapValues({ $0.jsonValue }))
    }
}

public extension Dictionary where Key == String, Value: JSONRepresentable {
    public var jsonRepresantable: JSONRepresentable {
        return JSONDict<Value>(self)
    }
}

public extension Dictionary where Key == String, Value: JSONInitializable {
    public init(json: JSON) throws {
        self = try json.dictionaryValue().reduce(into: [:], { result, item in
            do {
                result[item.key] = try Value(json: item.value)
            } catch let error as JSONModelError {
                throw JSONModelError.invalidValueFor(key: item.key, error)
            }
        })
    }
}

public extension Date {
    public func json(with transformer: DateTransformer) -> String {
        return transformer.string(form: self)
    }
}

// MARK: - JSONType
public extension JSONType {
    public func value() throws -> Bool {
        guard let boolValue = bool else { throw JSONModelError.invalidElement }
        return boolValue
    }
    
    public func value() throws -> Int {
        guard let intValue = int else { throw JSONModelError.invalidElement }
        return intValue
    }
    
    public func value() throws -> Double {
        guard let doubleValue = double else { throw JSONModelError.invalidElement }
        return doubleValue
    }
    
    public func value() throws -> String {
        guard let stringValue = string else { throw JSONModelError.invalidElement }
        return stringValue
    }
    
    public func arrayValue() throws -> [Self] {
        guard let arrayValue = array else { throw JSONModelError.invalidElement }
        return arrayValue
    }
    
    public func dictionaryValue() throws -> [String: Self] {
        guard let dictValue = dictionary else { throw JSONModelError.invalidElement }
        return dictValue
    }
}

public protocol JSONString: RawRepresentable, JSONInitializable, JSONRepresentable {
    init?(rawValue: String)
    var rawValue: String { get }
}

public extension JSONString {
    public init(json: JSON) throws {
        guard let object = Self.init(rawValue: try String(json: json) ) else {
            throw JSONModelError.invalidElement
        }
        self = object
    }
    
    public var jsonValue: JSON {
        return rawValue.jsonValue
    }
}

extension JSON: JSONType {
    public init(bool: Bool) { self.init(bool) }
    public init(int: Int) { self.init(int) }
    public init(double: Double) { self.init(double) }
    public init(string: String) { self.init(string) }
    public init(array: [JSON]) { self.init(array) }
    public init(dictionary: [String: JSON]) { self.init(dictionary) }
}

// MARK: - JSON Models
public extension JSONObjectInitializable where PropertyKey.RawValue == String {
    init(json: JSON) throws {
        let jsonObject = try JSONObject<PropertyKey>(json: json)
        try self.init(object: jsonObject)
    }
}

public extension JSONObjectRepresentable where PropertyKey.RawValue == String {
    var jsonValue: JSON {
        return JSONObject<PropertyKey>(dictValue).jsonValue
    }
}

// MARK: - JSONObject
public struct JSONObject<PropertyType: RawRepresentable & Hashable>: JSONInitializable {
    fileprivate let json: JSON
    
    public init(json: JSON) throws {
        guard json.type == .dictionary else {
            throw JSONModelError.jsonIsNotAnObject
        }
        self.json = json
    }
}

extension JSONObject: JSONRepresentable {
    public var jsonValue: JSON {
        return json
    }
}

public extension JSONObject where PropertyType.RawValue == String {
    public init(_ jsonDict: [PropertyType: JSONRepresentable?]) {
        json = JSON(jsonDict.reduce(into: [:], { $0[$1.key.rawValue] = $1.value?.jsonValue ?? .null }))
    }
    
    public subscript(key: PropertyType) -> JSON {
        return json[key.rawValue]
    }
    
    // MARK: - Throwable methods
    public func object(for key: PropertyType) throws -> JSONObject<PropertyType> {
        do {
            return try JSONObject<PropertyType>(json: self[key])
        } catch let error as JSONModelError {
            throw JSONModelError.invalidValueFor(key: key.rawValue, error)
        }
    }
    
    // MARK: - Value for keypath with custom tranform
    public func value<T>(for keyPath: PropertyType..., with transform: (JSON) throws -> T) throws -> T {
        return try value(for: ArraySlice(keyPath), with: transform)
    }
    
    public func value<T>(for keyPath: PropertyType..., with transform: (JSON) throws -> T) throws -> T? {
        return try value(for: ArraySlice(keyPath), with: transform)
    }
    
    private func value<T>(for keyPath: ArraySlice<PropertyType>, with transform: (JSON) throws -> T) throws -> T {
        assert(keyPath.isEmpty == false, "KeyPath cannot be empty")
        
        let key = keyPath.first!
        do {
            if keyPath.count == 1 {
                return try transform(self[key])
            } else {
                let subPath = keyPath[keyPath.startIndex.advanced(by: 1)...]
                return try JSONObject(json: self[key]).value(for: subPath, with: transform)
            }
        } catch let error as JSONModelError {
            throw JSONModelError.invalidValueFor(key: key.rawValue, error)
        }
    }
    
    private func value<T>(for keyPath: ArraySlice<PropertyType>, with transform: (JSON) throws -> T) throws -> T? {
        return try value(for: keyPath, with: { (json) -> T? in
            switch json.type {
            case .null:
                return nil
            default:
                return try transform(json)
            }
        })
    }
    
    // MARK: - Value for keypath - single object
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> T {
        return try value(for: ArraySlice(keyPath), with: T.init)
    }
    
    // MARK: - Value for keypath - array
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [T] {
        return try value(for: ArraySlice(keyPath)) { try Array(json: $0) }
    }
    
    // MARK: - Value for keypath - Dictionary
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [String: T] {
        return try value(for: ArraySlice(keyPath)) { try Dictionary(json: $0) }
    }
    
    // MARK: - Value for keypath - Date
    public func value(for keyPath: PropertyType..., with transformer: DateTransformer) throws -> Date {
        return try value(for: ArraySlice(keyPath)) { try transformer.date(from: try $0.value()) }
    }
    
    // MARK: - Value for keypath - flattened array
    public func flatMap<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [T] {
        return try value(for: ArraySlice(keyPath)) { try $0.arrayValue().lazy.flatMap({ try? T(json: $0) }) }
    }
    
    // MARK: - Optional methods
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> T? {
        return try value(for: ArraySlice(keyPath), with: T.init)
    }
    
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [T]? {
        return try value(for: ArraySlice(keyPath)) { try Array(json: $0) }
    }
    
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [String: T]? {
        return try value(for: ArraySlice(keyPath)) { try Dictionary(json: $0) }
    }
    
    public func value(for keyPath: PropertyType..., with transformer: DateTransformer) throws -> Date? {
        return try value(for: ArraySlice(keyPath)) { try transformer.date(from: try $0.value()) }
    }
}

// MARK: - Date Handling
public protocol DateTransformer {
    func date(from string: String) throws -> Date
    func string(form date: Date) -> String
}

extension String: DateTransformer {
    private static let dateFormatter = DateFormatter()
    
    private func formatter() -> DateFormatter {
        let formatter = String.dateFormatter
        formatter.dateFormat = self
        return formatter
    }
    
    public func date(from string: String) throws -> Date {
        guard let date = formatter().date(from: string) else {
            throw JSONModelError.invalidFormat
        }
        return date
    }
    
    public func string(form date: Date) -> String {
        return formatter().string(from: date)
    }
}

// MARK: - JSONModelError
public indirect enum JSONModelError: Error {
    case jsonIsNotAnObject
    case invalidElement
    case invalidFormat
    case invalidValueFor(key: String, JSONModelError)
}

extension JSONModelError: Equatable {
    public static func == (lhs: JSONModelError, rhs: JSONModelError) -> Bool {
        switch (lhs, rhs) {
        case (.jsonIsNotAnObject, .jsonIsNotAnObject), (.invalidElement, .invalidElement), (.invalidFormat, .invalidFormat):
            return true
        case let (.invalidValueFor(leftKey, leftError), .invalidValueFor(rightKey, rightError)):
            return leftKey == rightKey && leftError == rightError
        default:
            return false
        }
    }
}

extension JSONModelError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .jsonIsNotAnObject:
            return "JSON is not an object"
        case .invalidElement:
            return "Invalid element"
        case .invalidFormat:
            return "Invalid format"
        case let .invalidValueFor(key: key, error):
            var stringValue = "[\(key)]"
            
            if case .invalidValueFor(_) = error {
                stringValue.append(error.description)
            } else {
                stringValue.append(": \(error.description)")
            }
            
            return stringValue
        }
    }
}
