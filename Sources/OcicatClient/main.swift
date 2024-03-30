import Ocicat

private class SomeType {
}

typealias SomeTask = Int

class SomeDelegate {
    
}

private var source = SomeType()

extension SomeType {
    static var theKey: Key = nil
    
    var safeValue: SomeType? {
        get {
            #get(by: Self.theKey) as? SomeType
        }
        set {
            #set(by: Self.theKey)
        }
    }
}
