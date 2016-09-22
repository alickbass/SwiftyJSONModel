//
//  JSONArray.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 21/09/2016.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

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
