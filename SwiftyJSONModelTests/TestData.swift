//
//  TestData.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 21/09/2016.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import SwiftyJSONModel

struct Data {
    static let hobbies = ["Guitar", "Cycling", "Reading"]
    static let person = Person(firstName: "John", lastName: "Doe", age: 21, isMarried: false, height: 180, hobbies: hobbies)
    
    static let jsonObject = try! JSONObject<Person.PropertyKey>(json: person.jsonValue)
    static let emptyJsonObject = try! JSONObject<Person.PropertyKey>(json: JSON([String: JSON]()))
}
