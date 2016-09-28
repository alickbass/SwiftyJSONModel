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
    
    func testJSONBoolValue() {
        XCTAssertThrowsError(try JSON("test").boolValue(), "Non bool should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertEqual(try? JSON(true).boolValue(), true)
    }
    
    func testJSONIntValue() {
        XCTAssertThrowsError(try JSON("test").intValue(), "Non int should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertEqual(try? JSON(3).intValue(), 3)
    }
    
    func testJSONDoubleValue() {
        XCTAssertThrowsError(try JSON("test").doubleValue(), "Non double should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertEqual(try? JSON(3.0).doubleValue(), 3.0)
    }
    
    func testJSONStringValue() {
        XCTAssertThrowsError(try JSON(true).stringValue(), "Non string should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        XCTAssertEqual(try? JSON("test").stringValue(), "test")
    }
    
    func testJSONArrayValue() {
        XCTAssertThrowsError(try JSON(true).arrayValue(), "Non array should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        let json: [JSON] = ["Some"]
        XCTAssertEqual(try! JSON(json).arrayValue(), json)
    }
    
    func testJSONDictionaryValue() {
        XCTAssertThrowsError(try JSON(true).dictionaryValue(), "Non array should throw error") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        let json: [String: JSON] = ["SomeKey": "SomeValue"]
        XCTAssertEqual(try! JSON(json).dictionaryValue(), json)
    }
    
}
