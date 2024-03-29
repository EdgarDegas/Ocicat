import Ocicat

private class SomeType {
}

typealias SomeTask = Int

class SomeDelegate {
    
}

private #Keys("key")

private var source = SomeType()

extension SomeType {
    @Ocicated(source: "source", key: "Keys.key")
    var task: SomeTask?
    
    func f() {
        
    }
}


extension SomeType {
    static var theKey: Void?
    
    var safeValue: SomeType? {
        get {
            #getter(key: "Self.theKey") as? SomeType
        }
        set {
            #setter(key: "Self.theKey")
        }
    }
}
