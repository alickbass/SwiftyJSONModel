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
            throw JSONModelError.invalidJSON
        }
        self.json = json
    }
}

public extension JSONObject where PropertyType.RawValue == String {
    public func value<T: JSONInitializable>(for key: PropertyType) throws -> T {
        return try T(json: json[key.rawValue])
    }
    
    public func value<T: JSONInitializable>(for key: PropertyType) -> T? {
        return try? value(for: key)
    }
}
