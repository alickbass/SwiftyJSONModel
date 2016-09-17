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

struct FullName {
    let firstName: String
    let lastName: String
}

extension FullName: JSONModelType {
    enum PropertyKey: String {
        case firstName, lastName
    }
    
    init(properties: [PropertyKey : JSON]) throws {
        firstName = try properties.value(for: .firstName).stringValue()
        lastName = try properties.value(for: .lastName).stringValue()
    }
    
    var dictValue: [PropertyKey : JSON] {
        return [.firstName: JSON(firstName), .lastName: JSON(lastName)]
    }
}

extension FullName: Equatable {}
func == (left: FullName, right: FullName) -> Bool {
    return left.firstName == right.firstName && left.lastName == right.lastName
}

class SwiftyJSONModelTests: XCTestCase {
    
    func testJSONModelProtocols() {
        let name = FullName(firstName: "John", lastName: "Doe")
        XCTAssertEqual(try? FullName(json: name.jsonValue), name)
    }
    
}
