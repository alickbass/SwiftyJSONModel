//
//  JSONProtocols.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 14/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public indirect enum JSONModelError: Error, Equatable {
    case jsonIsNotAnObject
    case invalidElement
    case invalidValueFor(key: String, JSONModelError)
}

public func == (lhs: JSONModelError, rhs: JSONModelError) -> Bool {
    switch (lhs, rhs) {
    case (.jsonIsNotAnObject, .jsonIsNotAnObject), (.invalidElement, .invalidElement):
        return true
    case let (.invalidValueFor(leftKey, leftError), .invalidValueFor(rightKey, rightError)):
        return leftKey == rightKey && leftError == rightError
    default:
        return false
    }
}

public protocol PropertiesContaining {
    associatedtype PropertyKey: RawRepresentable, Hashable
}

public protocol JSONObjectInitializable: PropertiesContaining, JSONInitializable {
    init(object: JSONObject<PropertyKey>) throws
}

public protocol JSONObjectRepresentable: PropertiesContaining, JSONRepresentable {
    var dictValue: [PropertyKey: JSONRepresentable] { get }
}

public protocol JSONModelType: JSONObjectInitializable, JSONObjectRepresentable {}

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

