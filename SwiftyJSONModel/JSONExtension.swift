//
//  JSONExtension.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 17/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON: JSONType {
    public init(bool: Bool) { self.init(bool) }
    public init(int: Int) { self.init(int) }
    public init(double: Double) { self.init(double) }
    public init(string: String) { self.init(string) }
    public init(array: [JSON]) { self.init(array) }
    public init(dictionary: [String: JSON]) { self.init(dictionary) }
}
