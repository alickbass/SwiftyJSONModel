//
//  JSONProtocols.swift
//  StreetSmart
//
//  Created by Oleksii on 14/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum JSONModelError: Error {
    case jsonIsNotAnObject
    case unexpectedElement
    case elementAbsent
    case invalidElement
    case invalidUUIDString
}

public protocol PropertiesContaining {
    associatedtype PropertyKey: RawRepresentable, Hashable
}

public protocol JSONInitializable: PropertiesContaining {
    init(json: JSON) throws
    init(properties: [PropertyKey: JSON]) throws
}

public protocol JSONRepresentable: PropertiesContaining {
    var jsonValue: JSON { get }
    var dictValue: [PropertyKey: JSON] { get }
}

public protocol JSONModelType: JSONInitializable, JSONRepresentable {}

public extension JSONInitializable where PropertyKey.RawValue == String {
    public init(json: JSON) throws {
        guard let dictionary = json.dictionary else {
            throw JSONModelError.jsonIsNotAnObject
        }
        
        var properties = [PropertyKey: JSON]()
        
        try dictionary.forEach({ key, value in
            guard let propertyKey = PropertyKey(rawValue: key) else {
                throw JSONModelError.unexpectedElement
            }
            properties[propertyKey] = value
        })
        
        try self.init(properties: properties)
    }
}

public extension JSONRepresentable where PropertyKey.RawValue == String {
    public var jsonValue: JSON {
        var dict = [String: JSON]()
        for (key, value) in dictValue {
            dict[key.rawValue] = value
        }
        return JSON(dict)
    }
}
