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

extension String: JSONRepresentable {
    public var jsonValue: JSON { return JSON(self) }
}

extension Bool: JSONRepresentable {
    public var jsonValue: JSON { return JSON(self) }
}

extension Int: JSONRepresentable {
    public var jsonValue: JSON { return JSON(self) }
}

extension Double: JSONRepresentable {
    public var jsonValue: JSON { return JSON(self) }
}
