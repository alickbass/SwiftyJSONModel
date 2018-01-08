//
//  JSONObjectType.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 19/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

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
