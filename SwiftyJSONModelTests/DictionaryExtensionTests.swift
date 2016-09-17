//
//  DictionaryExtensionTests.swift
//  SwiftyJSONModel
//
//  Created by Oleksii on 17/09/16.
//  Copyright © 2016 Oleksii Dykan. All rights reserved.
//

import XCTest
@testable import SwiftyJSONModel

class DictionaryExtensionTests: XCTestCase {
    
    func testValueForKey() {
        let key = "testKey"
        let value = "test"
        
        XCTAssertThrowsError(try [:].value(for: key), "If there is no element throw exeption") { error in
            XCTAssertEqual(error as? JSONModelError, .elementAbsent)
        }
        XCTAssertEqual(try? [key: value].value(for: key), value)
    }
    
}
