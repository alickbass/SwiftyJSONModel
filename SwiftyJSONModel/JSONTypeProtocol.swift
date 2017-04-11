//
//  JSONTypeProtocol.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 07/03/2017.
//  Copyright © 2017 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONType {
    var bool: Bool? { get }
    var int: Int? { get }
    var double: Double? { get }
    var string: String? { get }
    var array: [Self]? { get }
    var dictionary: [String: Self]? { get }
    
    init(bool: Bool)
    init(int: Int)
    init(double: Double)
    init(string: String)
    init(array: [Self])
    init(dictionary: [String: Self])
    
    func value() throws -> Bool
    func value() throws -> Int
    func value() throws -> Double
    func value() throws -> String
    func arrayValue() throws -> [Self]
    func dictionaryValue() throws -> [String: Self]
}

public extension JSONType {
    public func value() throws -> Bool {
        guard let boolValue = bool else { throw JSONModelError.invalidElement }
        return boolValue
    }
    
    public func value() throws -> Int {
        guard let intValue = int else { throw JSONModelError.invalidElement }
        return intValue
    }
    
    public func value() throws -> Double {
        guard let doubleValue = double else { throw JSONModelError.invalidElement }
        return doubleValue
    }
    
    public func value() throws -> String {
        guard let stringValue = string else { throw JSONModelError.invalidElement }
        return stringValue
    }
    
    public func arrayValue() throws -> [Self] {
        guard let arrayValue = array else { throw JSONModelError.invalidElement }
        return arrayValue
    }
    
    public func dictionaryValue() throws -> [String: Self] {
        guard let dictValue = dictionary else { throw JSONModelError.invalidElement }
        return dictValue
    }
}

extension JSON: JSONType {
    public init(bool: Bool) { self.init(bool) }
    public init(int: Int) { self.init(int) }
    public init(double: Double) { self.init(double) }
    public init(string: String) { self.init(string) }
    public init(array: [JSON]) { self.init(array) }
    public init(dictionary: [String: JSON]) { self.init(dictionary) }
}
