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
private var keyToTask: Key = nil
private var someOtherKey: Key = nil

extension SomeProtocol {
    var task: SomeTask? {
        #get(by: keyToTask) as? SomeTask
    }
    
    var value: Int {
        get { #get(by: someOtherKey) as? Int ?? 1 }
        set { #set(by: someOtherKey) }
    }
}

```

You can refer to another object as source:

```swift
static var customSourcedKey: Key = nil
var customSourcedObject: Int? {
    get {
        #get(from: anotherObject, by: Self.customSourcedKey) as? Int
    }
    set {
        #set(to: anotherObject, by: Self.customSourcedKey)
    }
}
```

Supports weak reference out of the box:

```swift
var weakObject: A? {
    get {
        #get(by: key) as? SomeRefType
    }
    set {
        #weaklySet(by: key)
    }
}
```

Setter sets `newValue` by default, but you can set whatever you want:
```swift
#set(1, by: key)
```
