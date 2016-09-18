//
//  SwiftyJSONModelTests.swift
//  SwiftyJSONModelTests
//
//  Created by Oleksii on 17/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import SwiftyJSONModel

struct Person {
    let firstName: String
    let lastName: String
    let age: Int
    let isMarried: Bool
    let height: Double
}

extension Person: JSONModelType {
    enum PropertyKey: String {
        case firstName, lastName, age, isMarried, height
    }
    
    init(properties: [PropertyKey : JSON]) throws {
        firstName = try properties.value(for: .firstName).stringValue()
        lastName = try properties.value(for: .lastName).stringValue()
        age = try properties.value(for: .age).intValue()
        isMarried = try properties.value(for: .isMarried).boolValue()
        height = try properties.value(for: .height).doubleValue()
    }
    
    var dictValue: [PropertyKey : JSONRepresentable] {
        return [.firstName: firstName, .lastName: lastName, .age: age, .isMarried: isMarried, .height: height]
    }
}

extension Person: Equatable {}
func == (left: Person, right: Person) -> Bool {
    return left.firstName == right.firstName && left.lastName == right.lastName &&
           left.age == right.age && left.isMarried == right.isMarried && left.height == right.height
}

class SwiftyJSONModelTests: XCTestCase {
    
    func testJSONModelProtocols() {
        let person = Person(firstName: "John", lastName: "Doe", age: 21, isMarried: false, height: 180)
        XCTAssertEqual(try? Person(json: person.jsonValue), person)
    }
    
}
