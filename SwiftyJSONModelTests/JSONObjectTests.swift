//
//  JSONObjectTypeTests.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 19/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import SwiftyJSONModel

class JSONObjectTests: XCTestCase {
    
    let person = Person(firstName: "John", lastName: "Doe", age: 21, isMarried: false, height: 180)
    
    func testJSONObjectThrowableValueForKey() {
        let jsonObject = try! JSONObject<Person.PropertyKey>(json: person.jsonValue)
        let emptyJsonObject = try! JSONObject<Person.PropertyKey>(json: JSON([String: JSON]()))
        
        XCTAssertEqual(try? jsonObject.value(for: .firstName), person.firstName)
        XCTAssertEqual(try? jsonObject.value(for: .lastName), person.lastName)
        XCTAssertEqual(try? jsonObject.value(for: .age), person.age)
        XCTAssertEqual(try? jsonObject.value(for: .isMarried), person.isMarried)
        XCTAssertEqual(try? jsonObject.value(for: .height), person.height)
        
        XCTAssertThrowsError(try JSONObject<Person.PropertyKey>(json: JSON(5)), "Init with non object hould fail") { error in
            XCTAssertEqual(error as? JSONModelError, .invalidJSON)
        }
        
        do {
            let firstName: String = try emptyJsonObject.value(for: .firstName)
            XCTFail("\(firstName) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        do {
            let lastName: String = try emptyJsonObject.value(for: .lastName)
            XCTFail("\(lastName) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        do {
            let age: Int = try emptyJsonObject.value(for: .age)
            XCTFail("\(age) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        do {
            let isMarried: Bool = try emptyJsonObject.value(for: .isMarried)
            XCTFail("\(isMarried) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        do {
            let height: Double = try emptyJsonObject.value(for: .height)
            XCTFail("\(height) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
        
        do {
            let firstName: Double = try jsonObject.value(for: .firstName)
            XCTFail("\(firstName) method should throw")
        } catch let error {
            XCTAssertEqual(error as? JSONModelError, .invalidElement)
        }
    }
    
    func testJSONObjectOptionalValueForKey() {
        let jsonObject = try! JSONObject<Person.PropertyKey>(json: person.jsonValue)
        let emptyJsonObject = try! JSONObject<Person.PropertyKey>(json: JSON([String: JSON]()))
        
        let firstName: String? = jsonObject.value(for: .firstName)
        let lastName: String? = jsonObject.value(for: .lastName)
        let age: Int? = jsonObject.value(for: .age)
        let isMarried: Bool? = jsonObject.value(for: .isMarried)
        let height: Double? = jsonObject.value(for: .height)
        
        let nilFirstName: Double? = jsonObject.value(for: .firstName)
        let emptyFirstName: String? = emptyJsonObject.value(for: .firstName)
        let emptyLastName: String? = emptyJsonObject.value(for: .lastName)
        let emptyAge: Int? = emptyJsonObject.value(for: .age)
        let emptyIsMarried: Bool? = emptyJsonObject.value(for: .isMarried)
        let emptyHeight: Double? = emptyJsonObject.value(for: .height)
        
        XCTAssertEqual(firstName, person.firstName)
        XCTAssertEqual(lastName, person.lastName)
        XCTAssertEqual(age, person.age)
        XCTAssertEqual(isMarried, person.isMarried)
        XCTAssertEqual(height, person.height)
        XCTAssertNil(nilFirstName)
        XCTAssertNil(emptyFirstName)
        XCTAssertNil(emptyLastName)
        XCTAssertNil(emptyAge)
        XCTAssertNil(emptyIsMarried)
        XCTAssertNil(emptyHeight)
    }
}
