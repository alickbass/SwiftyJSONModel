# SwiftyJSONModel
A microframework that helps to use [Swifty JSON](https://github.com/SwiftyJSON/SwiftyJSON) with your custom models in a easy and type-safe way

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Build Status](https://travis-ci.org/alickbass/SwiftyJSONModel.svg?branch=master)](https://travis-ci.org/alickbass/SwiftyJSONModel)
[![codecov](https://codecov.io/gh/alickbass/SwiftyJSONModel/branch/master/graph/badge.svg)](https://codecov.io/gh/alickbass/SwiftyJSONModel)

## Motivation:

### The full motivation and description is [here](https://medium.com/@alickdikan/type-safe-json-in-swift-with-swiftyjsonmodel-89d432a8c1ee#.d07xuncxy)

For the following `JSON`:

```json
{
  "name": "John",
  "age": 25,
  "isMarried": false,
  "height": 170.0,
  "address": {
  	"city": "San-Fransisco",
  	"country": "USA"
  },
  "hobbies": ["bouldering", "guitar", "swift:)"]
}
```

to map to the following model:

```swift
struct Person {
    let name: String
    let age: Int
    let isMarried: Bool
    let height: Double
    let city: String
    let country: String
    let hobbies: [String]?
}
```

**Instead** of the following:

```swift
extension Person {
    init?(jsonDict: [String: Any]) {
        guard let name = jsonDict["name"] as? String,
            let age = jsonDict["age"] as? Int,
            let isMarried = jsonDict["isMarried"] as? Bool,
            let height = jsonDict["height"] as? Double,
            let address = jsonDict["address"] as? [String: Any],
            let city = address["city"] as? String,
            let country = address["country"] as? String
            else {
            return nil
        }
        
        self.name = name
        self.age = age
        self.isMarried = isMarried
        self.height = height
        self.city = city
        self.country = country
        hobbies = jsonDict["hobbies"] as? [String]
    }
}
```

**We get the following:**

```swift
import SwiftyJSONModel

extension Person: JSONModelType {
    enum PropertyKey: String {
        case name, age, isMarried, height, hobbies
        case address, country, city
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        name = try object.value(for: .name)
        age = try object.value(for: .age)
        isMarried = try object.value(for: .isMarried)
        height = try object.value(for: .height)
        city = try object.value(for: .address, .city) // Accessing nested json
        country = try object.value(for: .address, .country) // Accessing nested json
        hobbies = try object.value(for: .hobbies)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .name: name,
            .age: age,
            .isMarried: isMarried,
            .height: height,
            .city: city,
            .country: country,
            .hobbies: hobbies?.jsonRepresantable,
        ]
    }
}
```

## What we improved:
* Keys are now restricted to the `PropertyKey` enum and we will have a compile error if we try to use something different.
* Autocomplition will help us navigate through available keys
* The constructor now `throws` which means that the init will fail if some value or it's type was different from what we expected and the `Error` will tell us exactly which property in `JSON` was wrong
* The type of the value for key is now inferred from the property we specify. That means we do not need to have all this boilerplate code with casting to `String` or `Int`. It will be done for us.

#Integration

## CocoaPods (iOS 8+)

You can use CocoaPods to install SwiftyJSONModel by adding it to your Podfile:

```swift
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
pod 'SwiftyJSONModel'
end
```

Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 8.0:

## Carthage (iOS 8+)

You can use Carthage to install SwiftyJSONModel by adding it to your Cartfile:

```swift
github "alickbass/SwiftyJSONModel"
```

