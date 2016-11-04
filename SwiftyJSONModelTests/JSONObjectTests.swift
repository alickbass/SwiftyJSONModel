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
    typealias PersonKey = Person.PropertyKey
    
    func testJSONObjectThrowableValueForKey() {
        XCTAssertEqual(try? Data.jsonObject.value(for: .firstName), Data.person.firstName)
        XCTAssertEqual(try? Data.jsonObject.value(for: .lastName), Data.person.lastName)
        XCTAssertEqual(try? Data.jsonObject.value(for: .age), Data.person.age)
        XCTAssertEqual(try? Data.jsonObject.value(for: .isMarried), Data.person.isMarried)
        XCTAssertEqual(try? Data.jsonObject.value(for: .height), Data.person.height)
        
        XCTAssertThrowsError(try JSONObject<Person.PropertyKey>(json: JSON(5)), "Init with non object hould fail") { error in
            XCTAssertEqual(error as? JSONModelError, .jsonIsNotAnObject)
        }
        
        XCTAssertThrowsError(try Data.emptyJsonObject.value(for: .firstName) as String) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.firstName.rawValue, .invalidElement))
        }
        
        XCTAssertThrowsError(try Data.emptyJsonObject.value(for: .lastName) as String) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.lastName.rawValue, .invalidElement))
        }
        
        XCTAssertThrowsError(try Data.emptyJsonObject.value(for: .age) as Int) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.age.rawValue, .invalidElement))
        }
        
        XCTAssertThrowsError(try Data.emptyJsonObject.value(for: .isMarried) as Bool) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.isMarried.rawValue, .invalidElement))
        }
        
        XCTAssertThrowsError(try Data.emptyJsonObject.value(for: .height) as Double) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.height.rawValue, .invalidElement))
        }
        
        XCTAssertThrowsError(try Data.jsonObject.value(for: .firstName) as Double) { error in
            XCTAssertEqual(error as? JSONModelError, .invalidValueFor(key: PersonKey.firstName.rawValue, .invalidElement))
        }
    }
    
    func testJSONObjectOptionalValueForKey() {
        let jsonObject = try! JSONObject<Person.PropertyKey>(json: Data.person.jsonValue)
        let emptyJsonObject = try! JSONObject<Person.PropertyKey>(json: JSON([String: JSON]()))
        
        XCTAssertEqual(jsonObject.value(for: .firstName) as String?, Data.person.firstName)
        XCTAssertEqual(jsonObject.value(for: .lastName) as String?, Data.person.lastName)
        XCTAssertEqual(jsonObject.value(for: .age) as Int?, Data.person.age)
        XCTAssertEqual(jsonObject.value(for: .isMarried) as Bool?, Data.person.isMarried)
        XCTAssertEqual(jsonObject.value(for: .height) as Double?, Data.person.height)
        XCTAssertEqual((jsonObject.value(for: .hobbies) as [String]?)!, Data.person.hobbies!)
        
        XCTAssertNil(jsonObject.value(for: .firstName) as Double?)
        XCTAssertNil(emptyJsonObject.value(for: .firstName) as String?)
        XCTAssertNil(emptyJsonObject.value(for: .lastName) as String?)
        XCTAssertNil(emptyJsonObject.value(for: .age) as Int?)
        XCTAssertNil(emptyJsonObject.value(for: .isMarried) as Bool?)
        XCTAssertNil(emptyJsonObject.value(for: .height) as Double?)
        XCTAssertNil(emptyJsonObject.value(for: .hobbies) as [String]?)
    }
}
