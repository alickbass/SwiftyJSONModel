//
//  JSONExtension.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 17/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public extension JSON {
    public func value<T: Any>() throws -> T {
        guard let value = object as? T else { throw JSONModelError.invalidElement }
        return value
    }
    
    public func arrayValue() throws -> [JSON] {
        guard let arrayValue = array else { throw JSONModelError.invalidElement }
        return arrayValue
    }
    
    public func dictionaryValue() throws -> [String: JSON] {
        guard let dictValue = dictionary else { throw JSONModelError.invalidElement }
        return dictValue
    }
}
