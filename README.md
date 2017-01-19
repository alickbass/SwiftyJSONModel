# SwiftyJSONModel
A microframework that helps to use [Swifty JSON](https://github.com/SwiftyJSON/SwiftyJSON) with your custom models in a easy and type-safe way

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Build Status](https://travis-ci.org/alickbass/SwiftyJSONModel.svg?branch=master)](https://travis-ci.org/alickbass/SwiftyJSONModel)
[![codecov](https://codecov.io/gh/alickbass/SwiftyJSONModel/branch/master/graph/badge.svg)](https://codecov.io/gh/alickbass/SwiftyJSONModel)

##Motivation:
Let's consider a very simple model:

```swift
struct Person {
    let firstName: String
    let lastName: String
    let age: Int
}
```
Usually, if we want our model to support initialization from `JSON` using `SwiftyJSON` framework, we would have something like this:

```swift
import SwiftyJSON

extension Person {
    init(json: JSON) {
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        age = json["age"].intValue
    }

    var jsonValue: JSON {
        return ["firstName": firstName, "lastName": lastName, "age": age]
    }
}
```
There are several problems with this code:

  * The key for our properties are raw strings and it is easy to make a typo in the key
  * These subscript method will return value even if there is none in the original JSON. But we want to really know when the json is invalid.

###The first solution

The easiest way to take advantage of swift type system is to put all the key in json into `Enum`. Here's an example:

```swift
import SwiftyJSON

extension Person {
    enum PropertyKey: String {
        case firstName, lastName, age
    }
    
    init(json: JSON) {
        firstName = json[PropertyKey.firstName.rawValue].stringValue
        lastName = json[PropertyKey.lastName.rawValue].stringValue
        age = json[PropertyKey.age.rawValue].intValue
    }

    var jsonValue: JSON {
        return [PropertyKey.firstName.rawValue: firstName,
                PropertyKey.lastName.rawValue: lastName,
                PropertyKey.age.rawValue: age]
    }
}
```

But this code still has several problems:

* Although we use enums for our constants, no one restricts us from using some invalid string as a key. Like: `age = json["superRandomKey"].intValue`
* Still we have no clue if the json is actually valid
* We should always manually call the proper method to get proper value. For `int` `intValue`, for `string` - `stringValue`.

#Can we do better?
Yes we can! And here is where our microframework comes to place. 
## Example of usage
Here is the same model but using the `SwiftyJSONModel`:

```swift
import SwiftyJSONModel

extension Person: JSONModelType {
    enum PropertyKey: String {
        case firstName, lastName, age
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        firstName = try object.value(for: .firstName)
        lastName = try object.value(for: .lastName)
        age = try object.value(for: .age)
    }

    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [.firstName: firstName, .lastName: lastName, .age: age]
    }
}

let personJSON = //JSON that we'll use for our model
do {
    let person = try Person(json: personJSON)
    print(person.jsonValue)
} catch let error {
    print(error)
}
```

Although from outside init method stays the same, we now solved all the issues that we had before:

* Keys are now restricted to the `PropertyKey` enum and we will have a compile error if we try to use something different.
* The constructor now `throws` which means that the init will fail if some value or it's type was different from what we expected
* The type of the value for key is now inferred from the property we specify. That means we do not need to have all this boilerplate code with `stringValue` or `intValue`. It will be done for us.

##Nested JSON:
Imagine that with use some public `API` that has the following json structure:

```json
{
  "name": "Swifty Boulevard",
  "number": 43,
  "city": {
    "name": "Cocoa",
    "country": {
      "name": "Morocco",
      "continent": "Africa"
    }
  }
}
```

So here we have a nested json where the `root` is object, `city` is object and `country` is object. Imagine that we don't really need all the objects structure, but we would rather have `city` as `String` and `country` as `String` instead of objects. and we would like to have the following model:

```swift
struct Street {
    let name: String
    let number: Int?
    let city: String
    let country: String
}
```

So what we want, is to exctract `name` of `city` and `name` of `country` and use it for the properties. This is how it would look like with `SwiftyJSONModel`:

```swift
extension Street: JSONObjectInitializable {
    enum PropertyKey: String {
        case name, number, city, country
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        name = try object.value(for: .name)
        number = object.value(for: .number)
        city = try object.value(for: .city, .name)
        country = try object.value(for: .city, .country, .name)
    }
}
```

So now instead of providing the `key` to property we need, we provide the whole key path. For the `city` is was: `.city, .name` and for the country it was `.city, .country, .name`. As easy as that.

##Recursive errors:
Imagine that we have an error in the `Street` json we saw above and something like this arrives:

```json
{
  "name": "Swifty Boulevard",
  "number": 43,
  "city": {
    "name": "Cocoa",
    "country": {
      "name": 23,
      "continent": "Africa"
    }
  }
}
```

Here the name of `Country` is `23` and we expect it to be `String`

We still have the same model as we had before, but now when we will try to construct the `Street` json, it will give us the following error:

```
[city][country][name]: Invalid element
```

So now we can immediately see what exactly went wrong and what field in json was corrupt. This feature is really powerful to debug the json that has a nested structure, especially when your back-end changes fast and you need to reflect to the changes as quick as possible 😉
