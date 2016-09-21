# SwiftyJSONModel
A microframework that helps to use Swifty JSON with your custom models in a easy and type-safe way

##Motivation:
Let's consider a very simple model:

```swift
import SwiftyJSON

struct Person {
    let firstName: String
    let lastName: String
    let age: Int
}
```
Usually, if we want our model to support initialization from `JSON` using `SwiftyJSON` framework, we would have something like this:

```swift
extension Person {
    init(json: JSON) {
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        age = json["age"].intValue
    }
}
```
There are several problems with this code:

  * The key for our properties are raw strings and it is easy to make a typo in the key
  * These subscript method will return value even if there is none in the original JSON. But we want to really now when the json is invalid.

###The first solution

The easiest way to take advatage of swift type system is to put all the key in json into `Enum`. Here's an example:

```swift
extension Person {
    enum PropertyKey: String {
        case firstName, lastName, age
    }
    
    init(json: JSON) {
        firstName = json[PropertyKey.age.rawValue].stringValue
        lastName = json[PropertyKey.lastName.rawValue].stringValue
        age = json[PropertyKey.age.rawValue].intValue
    }
}
```

But this code still has several problems:

* Although we use enums for our constants, noone restricts us from using some invalid string as a key. Like: `age = json["superRandomKey"].intValue`
* Still we have no clue if the json is actually valid
* We should always manually call the proper method to get proper value. For `int` `intValue`, for `string` - `stringValue`.

#Can we do better?
Yes we can! And here is where our microframework comes to place. 
## Example of usage
Here is the same model but using the `SwiftyJSONModel`:

```swift
extension Person: JSONObjectInitializable {
    enum PropertyKey: String {
        case firstName, lastName, age
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        firstName = try object.value(for: .firstName)
        lastName = try object.value(for: .lastName)
        age = try object.value(for: .age)
    }
}

func some() {
    let personJSON = //JSON that we'll use for our model
    do {
        let person = try Person(json: personJSON)
    } catch let error {
        print(error)
    }
}
```

Although from outside init method stays the same, we now solved all the issues that we had before:

* Keys are now restricted to the `PropertyKey` enum and we will have a compile error if we try to use something different.
* The constructor now `throws` which means that the init will fail if some value or it's type was different from what we expected
* The type of the value for key is now inferred from the property we specify. That means we do not need to have all this boilerplate code with `stringValue` or `intValue`. It will be done for us.


