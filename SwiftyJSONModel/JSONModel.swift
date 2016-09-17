//
//  JSONProtocols.swift
//  StreetSmart
//
//  Created by Oleksii on 14/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum JSONModelError: Error {
    case jsonIsNotAnObject
    case unexpectedElement
    case elementAbsent
    case invalidElement
    case invalidUUIDString
}

protocol PropertiesContaining {
    associatedtype PropertyKey: RawRepresentable, Hashable
}

protocol JSONInitializable: PropertiesContaining {
    init(json: JSON) throws
    init(properties: [PropertyKey: JSON]) throws
}

protocol JSONRepresentable: PropertiesContaining {
    var jsonValue: JSON { get }
    var dictValue: [PropertyKey: JSON] { get }
}

protocol JSONModelType: JSONInitializable, JSONRepresentable {}

extension JSONInitializable where PropertyKey.RawValue == String {
    init(json: JSON) throws {
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
