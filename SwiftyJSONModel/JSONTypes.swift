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

public protocol JSONRepresantable {
    var jsonValue: JSON { get }
}


