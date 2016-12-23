//
//  JSONModelErrorTests.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 28/09/2016.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import XCTest
import SwiftyJSONModel

class JSONModelErrorTests: XCTestCase {
    
    func testErrorEquatable() {
        XCTAssertEqual(JSONModelError.invalidElement, .invalidElement)
        XCTAssertEqual(JSONModelError.jsonIsNotAnObject, .jsonIsNotAnObject)
        XCTAssertEqual(JSONModelError.invalidValueFor(key: "test", .invalidElement), .invalidValueFor(key: "test", .invalidElement))
        
        XCTAssertNotEqual(JSONModelError.invalidValueFor(key: "test", .invalidElement), .invalidValueFor(key: "other", .invalidElement))
        XCTAssertNotEqual(JSONModelError.invalidValueFor(key: "test", .invalidElement), .invalidElement)
        
    }
    
    func testErrorStringDescription() {
        let desiredDescription = "[country][city][name]: Invalid element"
        let error = JSONModelError.invalidValueFor(key: "country", .invalidValueFor(key: "city", .invalidValueFor(key: "name", .invalidElement)))
        XCTAssertEqual(error.description, desiredDescription)
        
        let objectErrorString = "[country]: \(JSONModelError.jsonIsNotAnObject.description)"
        XCTAssertEqual(JSONModelError.invalidValueFor(key: "country", .jsonIsNotAnObject).description, objectErrorString)
    }
}
