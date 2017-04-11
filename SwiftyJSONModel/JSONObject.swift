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
        var dict = [String: JSON]()
        
        for (key, value) in jsonDict {
            let jsonValue = value?.jsonValue ?? .null
            dict[key.rawValue] = jsonValue
        }
        
        json = JSON(dict)
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
    public func value<T>(for keyPath: PropertyType..., _ transform: (JSON) throws -> T) throws -> T {
        return try value(for: keyPath, transform)
    }
    
    private func value<T>(for keyPath: [PropertyType], _ transform: (JSON) throws -> T) throws -> T {
        assert(keyPath.isEmpty == false, "KeyPath cannot be empty")
        
        let key = keyPath[0]
        do {
            if keyPath.count == 1 {
                return try transform(self[key])
            } else {
                let subPath: [PropertyType] = .init(keyPath[1..<keyPath.count])
                return try JSONObject<PropertyType>(json: self[key]).value(for: subPath, transform)
            }
        } catch let error as JSONModelError {
            throw JSONModelError.invalidValueFor(key: key.rawValue, error)
        }
    }
    
    // MARK: - Value for keypath - single object
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> T {
        return try value(for: keyPath)
    }
    
    private func value<T: JSONInitializable>(for keyPath: [PropertyType]) throws -> T {
        return try value(for: keyPath, T.init)
    }
    
    // MARK: - Value for keypath - array
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [T] {
        return try value(for: keyPath)
    }
    
    private func value<T: JSONInitializable>(for keyPath: [PropertyType]) throws -> [T] {
        return try value(for: keyPath) {
            try $0.arrayValue().enumerated().lazy.map({ index, json in
                do {
                    return try T(json: json)
                } catch let error as JSONModelError {
                    throw JSONModelError.invalidValueFor(key: String(index), error)
                }
            })
        }
    }
    
    // MARK: - Value for keypath - flattened array
    public func flatMap<T: JSONInitializable>(for keyPath: PropertyType...) throws -> [T] {
        return try value(for: keyPath) { try $0.arrayValue().lazy.flatMap({ try? T(json: $0) }) }
    }
    
    // MARK: - Optional methods
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) -> T? {
        return try? value(for: keyPath)
    }
    
    public func value<T: JSONInitializable>(for keyPath: PropertyType...) -> [T]? {
        return try? value(for: keyPath)
    }
}
