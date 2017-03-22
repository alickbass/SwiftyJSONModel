//
//  JSONTypes.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 18/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONRepresentable {
    var jsonValue: JSON { get }
}

extension JSON: JSONInitializable, JSONRepresentable {
    public init(json: JSON) { self = json }
    public var jsonValue: JSON { return self }
}

extension String: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(string: self) }
}

extension Bool: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(bool: self) }
}

extension Int: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(int: self) }
}

extension Double: JSONInitializable, JSONRepresentable {
    public init(json: JSON) throws { self = try json.value() }
    public var jsonValue: JSON { return JSON(double: self) }
}
