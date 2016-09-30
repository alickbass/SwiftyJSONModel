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

public extension JSONInitializable {
    public init(json: JSON) throws {
        self = try json.value()
    }
}

public extension JSONRepresentable {
    public var jsonValue: JSON {
        return JSON(self)
    }
}

extension String: JSONInitializable, JSONRepresentable {}
extension Bool: JSONInitializable, JSONRepresentable {}
extension Int: JSONInitializable, JSONRepresentable {}
extension Double: JSONInitializable, JSONRepresentable {}
