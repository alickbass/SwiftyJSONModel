//
//  JSONModelError.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 23/12/2016.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation

public indirect enum JSONModelError: Error {
    case jsonIsNotAnObject
    case invalidElement
    case invalidValueFor(key: String, JSONModelError)
}

extension JSONModelError: Equatable {
    public static func == (lhs: JSONModelError, rhs: JSONModelError) -> Bool {
        switch (lhs, rhs) {
        case (.jsonIsNotAnObject, .jsonIsNotAnObject), (.invalidElement, .invalidElement):
            return true
        case let (.invalidValueFor(leftKey, leftError), .invalidValueFor(rightKey, rightError)):
            return leftKey == rightKey && leftError == rightError
        default:
            return false
        }
    }
}
