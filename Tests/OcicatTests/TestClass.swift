//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/21.
//

import Foundation
import Ocicat

class A { }

var anotherInstance = A()
var sourceForWeakObject = A()

final class TestClass {
    @Ocicated
    var object: Int?
    
    static let nonOptionalInitialValue = 40
    @Ocicated
    var nonOptional: Int = Self.nonOptionalInitialValue
    
    @Ocicated
    var unwrappedObject: Int!
    
    @Ocicated
    weak var weakRef: NSObject?
    
    var getterSetterKey: Key = nil
    
    var getterSetterObject: Int? {
        get {
            #get(by: getterSetterKey) as? Int
        }
        set {
            #set(by: getterSetterKey)
        }
    }
    
    static var customSourcedKey: Key = nil
    
    var customSourcedObject: Int? {
        get {
            #get(from: anotherInstance, by: Self.customSourcedKey) as? Int
        }
        set {
            #set(to: anotherInstance, by: Self.customSourcedKey)
        }
    }
    
    var another1 = 1
    var customSourcedKey1: Key = nil
    
    var customKeyedSourcedObject: Int? {
        get {
            #get(from: another1, by: customSourcedKey1) as? Int
        }
        set {
            #set(to: another1, by: customSourcedKey1)
        }
    }
    
    var keyToCustomWeakObject: Key = nil
    var customWeakObject: A? {
        get {
            #get(from: sourceForWeakObject, by: keyToCustomWeakObject) as? A
        }
        set {
            #weaklySet(to: sourceForWeakObject, by: keyToCustomWeakObject)
        }
    }
}
