import Ocicat

private class SomeType {
}

typealias SomeTask = Int

class SomeDelegate {
    
}


extension SomeType {
    @Ocicated
    var task: SomeTask?

    @Ocicated
    var delegate: SomeDelegate?
}

enum SomeState {
    case empty
}

extension SomeType {
    @Ocicated
    var state: SomeState!
}


protocol SomeProtocol {
    
}



private #Keys("keyToTask", "someOtherKey")

//extension SomeProtocol {
//    @Ocicated(keyName: "Keys.keyToTask")
//    var task: SomeTask?
//}


@AddKeys("key1", "key2")
struct MyKeys {
    
}

extension SomeProtocol {
    @Ocicated(keyName: "MyKeys.key1")
    var task: SomeTask?
}
