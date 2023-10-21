//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/21.
//

import ObjectiveC

public enum ObjcWrapper {
    public typealias Key = UnsafeRawPointer
    
    public static func get(
        from associatedObject: Any,
        by key: Key
    ) -> Any? {
        let object = objc_getAssociatedObject(associatedObject, key)
        if let weakRef = object as? WeakRef {
            if let object = weakRef.object {
                return object
            } else {
                save(nil, into: self, by: key)
                return nil
            }
        } else {
            return object
        } 
    }
    
    public static func save(
        _ newValue: Any?,
        into associatedObject: Any,
        by key: Key
    ) {
        objc_setAssociatedObject(
            associatedObject,
            key,
            newValue,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    public static func saveWeakReference(
        to newValue: AnyObject?,
        into associatedObject: Any,
        by key: Key
    ) {
        let weakReference = WeakRef(object: newValue)
        save(weakReference, into: associatedObject, by: key)
    }
}
