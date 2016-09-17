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
    public func boolValue() throws -> Bool {
        guard let boolValue = bool else {
            throw JSONModelError.elementAbsent
        }
        return boolValue
    }
    
    public func intValue() throws -> Int {
        guard let intValue = int else {
            throw JSONModelError.elementAbsent
        }
        return intValue
    }
    
    public func doubleValue() throws -> Double {
        guard let doubleValue = double else {
            throw JSONModelError.elementAbsent
        }
        return doubleValue
    }
    
    public func stringValue() throws -> String {
        guard let stringValue = string else {
            throw JSONModelError.elementAbsent
        }
        return stringValue
    }
    
    public func arrayValue() throws -> [JSON] {
        guard let arrayValue = array else {
            throw JSONModelError.elementAbsent
        }
        return arrayValue
    }
    
    public func uuidStringValue() throws -> String {
        guard let stringValue = string else {
            throw JSONModelError.elementAbsent
        }
        guard let uuidStrigValue = NSUUID(uuidString: stringValue) else {
            throw JSONModelError.invalidUUIDString
        }
        
        return uuidStrigValue.uuidString
    }
}
