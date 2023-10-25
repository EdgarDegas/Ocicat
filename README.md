![Logo](assets/Logo.png)

Ocicat uses Objective-C associated objects to allow you to define stored properties in Swift extensions.

For concret types, you can do it like this:

```swift
extension SomeType {
    @Ocicated
    var task: SomeTask?

    @Ocicated
    weak var delegate: SomeDelegate?
}
```

For protocol extensions, you need to declare your own keys, like this:

```swift
private #Keys("keyToTask", "someOtherKey")

extension SomeProtocol {
    @Ocicated(key: "Keys.keyToTask")  // don't miss the Keys. prefix here
    var task: SomeTask?
}
```

Ocicat can also help you define your own keychains:

```swift
@AddKeys("key1", "key2")
struct MyKeys {
    
}

extension SomeProtocol {
    @Ocicated(key: "MyKeys.key1")  // do add type name, in this case MyKeys., before key
    var task: SomeTask?
}
```



## How to Use It?

Alright. As long as you've [added this package in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app), when you attempt to compile, Xcode will ask you whether to trust and allow this macro package in the form of an error message. To be honest, I haven't tried what happens if you choose not to allow it, so...



## How Code Expands

Here is how the code mentioned above expands.

### For concret types

```swift
extension SomeType {
    @Ocicated
    var task: SomeTask?

    @Ocicated
    weak var delegate: SomeDelegate?
}
```

The above code will expand to:

```swift
extension SomeType {
    var task: SomeTask? {
        get {
            ObjcWrapper.get(from: self, by: &Self.keyToTask) as? SomeTask
        }
        set {
            ObjcWrapper.save(newValue, into: self, by: &Self.keyToTask)
        }
    }    
    
    fileprivate static var keyToTask: Void?
    
    weak var delegate: SomeDelegate?
        {
        get {
            ObjcWrapper.get(from: self, by: &Self.keyToDelegate) as? SomeDelegate
        }
        set {
            ObjcWrapper.saveWeakReference(to: newValue, into: self, by: &Self.keyToDelegate)
        }
    }
    
    fileprivate static var keyToDelegate: Void?
}
```

Basically, Ocicat defines a fileprivate static variable inside `SomeType` as a key, following the naming format "keyTo." It then defines a getter and a setter, and uses `ObjcWrapper` to invoke Objective-C methods for getting and setting values.

Ocicat offers an experience that closely resembles native Swift variables as much as possible. As shown in the above code, Ocicat can automatically support weak references. 

Meanwhile, if you define a non-optional variable, Ocicat will require you to provide a default value to avoid nil values. If you want to bypass this limitation, you can define the variable as a force-unwrapped one. For example, this won't compile:

```swift
extension SomeType {
    @Ocicated  // ❌ You must initialize non-optional variables to provide them with a default value.
    var state: SomeState
}
```

You need to provide a default value, by initializing it:

```swift
extension SomeType {
    @Ocicated
    var state: SomeState = .empty
}
```

Or, if you are absolutely certain that you will assign a value to it beforehand:

```SWIFT
extension SomeType {
    @Ocicated
    var state: SomeState!
}
```



### Custom Keys

For protocols, Ocicat cannot generate static variable keys for you, so you need to define the keys yourself. Fortunately, Ocicat provides macros for defining keys.

```swift
private #Keys("keyToTask", "someOtherKey")

extension SomeProtocol {
    @Ocicated(key: "Keys.keyToTask")
    var task: SomeTask?
}
```

This piece of code expands to:

```swift
private struct Keys {
    static var keyToTask: Void?
    static var someOtherKey: Void?
}

extension SomeProtocol {
    var task: SomeTask? {
        get {
            ObjcWrapper.get(from: self, by: &Keys.keyToTask) as? SomeTask
        }
        set {
            ObjcWrapper.save(newValue, into: self, by: &Keys.keyToTask)
        }
    }
}
```

The `#Keys(String...)` macro generates a structure named `Keys` and defines the keys you've named within it. You can customize the access modifier of `Keys`, as in the example where it is set to private, ensuring that it doesn't leak into other files.

Alternatively, if you decide to add your keys to an existing type, you can use the `#AddKeys(String...)` macro:

```SWIFT
@AddKeys("key1", "key2")
struct MyKeys {
    
}

extension SomeProtocol {
    @Ocicated(key: "MyKeys.key1")
    var task: SomeTask?
}
```

This expands to:

```swift
struct MyKeys {
    
    static var key1: Void?

    static var key2: Void?
    
}

extension SomeProtocol {
    var task: SomeTask? {
        get {
            ObjcWrapper.get(from: self, by: &MyKeys.key1) as? SomeTask
        }
        set {
            ObjcWrapper.save(newValue, into: self, by: &MyKeys.key1)
        }
    }
}
```

Please note that both `#Keys(String...)` and `#AddKeys(String...)`, as well as `#Ocicated(key: String)`, only accept string literals as input. In the source code, you can see that these macros actually accept `StringLiteralType` rather than `String`. The use of `String` in this document is for ease of understanding.

Fortunately, if you provide an incorrect key in `#Ocicated(key: String)`, the compiler can catch such spelling errors. When using `#Keys(String...)`, be mindful not to omit the `Keys.` prefix for keys, and when using `AddKeys(String...)`, be sure to prefix it with the name of your type.
