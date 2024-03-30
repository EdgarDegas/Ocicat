//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/21.
//

import Foundation
import Ocicat

var anotherInstance = TestClass()
var another1 = TestClass()

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
    
    static var customSourcedKey1: Key = nil
    
    var customKeyedSourcedObject: Int? {
        get {
            #get(from: another1, by: Self.customSourcedKey1) as? Int
        }
        set {
            #set(to: another1, by: Self.customSourcedKey1)
        }
    }
}
