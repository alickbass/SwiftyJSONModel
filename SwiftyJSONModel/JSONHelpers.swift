//
//  JSONArray.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 21/09/2016.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct JSONArray<T> where T: JSONInitializable & JSONRepresentable {
    public let array: [T]
    
    public init(_ array: [T]) {
        self.array = array
    }
}

extension JSONArray: JSONInitializable {
    public init(json: JSON) throws {
        guard json.type == .array else {
            throw JSONModelError.invalidJSON
        }
        array = try json.arrayValue().map({ try T(json: $0) })
    }
}

extension JSONArray: JSONRepresentable {
    public var jsonValue: JSON {
        return JSON(array.map({ $0.jsonValue }))
    }
}

extension Array where Element: JSONInitializable & JSONRepresentable {
    var jsonArray: JSONArray<Element> {
        return JSONArray<Element>(self)
    }
}
