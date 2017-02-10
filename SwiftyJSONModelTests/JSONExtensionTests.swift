//
//  JSONExtensionTests.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 17/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import SwiftyJSONModel

class JSONExtensionTests: XCTestCase {
    
    func testThrowableValue() {
        XCTAssertThrowsError(try JSON("test").value() as Bool) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertThrowsError(try JSON("test").value() as Int) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertEqual(try? JSON(true).value() as Bool, true)
        XCTAssertEqual(try? JSON(3).value() as Int, 3)
        XCTAssertEqual(try? JSON(0.0).value() as Int, 0)
        XCTAssertEqual(try? JSON(3.0).value() as Double, 3.0)
        XCTAssertEqual(try? JSON(-5).value() as Double, -5)
        XCTAssertEqual(try? JSON("test").value() as String, "test")
    }
    
    func testJSONArrayValue() {
        XCTAssertThrowsError(try JSON(true).arrayValue(), "Non array should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        let json: [JSON] = ["Some"]
        XCTAssertEqual(try! JSON(json).arrayValue, json)
    }
    
    func testJSONDictionaryValue() {
        XCTAssertThrowsError(try JSON(true).dictionaryValue(), "Non array should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        let json: [String: JSON] = ["SomeKey": "SomeValue"]
        XCTAssertEqual(try! JSON(json).dictionaryValue, json)
    }
    
}
