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
    case invalidJSON
    case jsonIsNotAnObject
    case unexpectedElement
    case elementAbsent
    case invalidElement
    case invalidUUIDString
}

public protocol PropertiesContaining {
    associatedtype PropertyKey: RawRepresentable, Hashable
}

public protocol JSONObjectInitializable: PropertiesContaining, JSONInitializable {
    init(properties: [PropertyKey: JSON]) throws
}

public protocol JSONObjectRepresentable: PropertiesContaining, JSONRepresentable {
    var jsonDictValue: [PropertyKey: JSON] { get }
    var dictValue: [PropertyKey: JSONRepresentable] { get }
}

public protocol JSONModelType: JSONObjectInitializable, JSONObjectRepresentable {}

public extension JSONObjectInitializable where PropertyKey.RawValue == String {
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

public extension JSONObjectRepresentable where PropertyKey.RawValue == String {
    public var jsonDictValue: [PropertyKey: JSON] {
        var dict = [PropertyKey: JSON]()
        for (key, value) in dictValue {
            dict[key] = value.jsonValue
        }
        return dict
    }
    
    public var jsonValue: JSON {
        var dict = [String: JSON]()
        for (key, value) in jsonDictValue {
            dict[key.rawValue] = value
        }
        return JSON(dict)
    }
}
