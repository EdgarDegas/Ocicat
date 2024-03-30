import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AssociatedByRuntimeTests: XCTestCase {
    let testClass = TestClass()
    
    func testOptional() {
        XCTAssertNil(testClass.object)
        
        let value = 9
        testClass.object = value
        XCTAssertEqual(testClass.object, value)
        
        testClass.object = nil
        XCTAssertNil(testClass.object)
    }
    
    func testNonOptional() {
        XCTAssertEqual(testClass.nonOptional, TestClass.nonOptionalInitialValue)
        
        let value = 18
        testClass.nonOptional = value
        XCTAssertEqual(testClass.nonOptional, value)
        
        let anotherValue = 88
        testClass.nonOptional = anotherValue
        XCTAssertEqual(testClass.nonOptional, anotherValue)
    }
    
    func testUnwrappedObject() {
        XCTAssertNil(testClass.unwrappedObject)
        
        let value = 42
        testClass.unwrappedObject = value
        XCTAssertEqual(testClass.unwrappedObject, value)
        
        testClass.unwrappedObject = nil
        XCTAssertNil(testClass.unwrappedObject)
    }
    
    func testWeakRef() {
        XCTAssertNil(testClass.weakRef)
        
        var object: NSObject? = NSObject()
        testClass.weakRef = object
        XCTAssertNotNil(testClass.weakRef)
        XCTAssert(testClass.weakRef == object)
        
        object = nil
        XCTAssertNil(testClass.weakRef)
    }
    
    func testGetterSetterObject() {
        XCTAssertNil(testClass.getterSetterObject)
        testClass.getterSetterObject = 40
        XCTAssert(testClass.getterSetterObject == 40)
        testClass.getterSetterObject = nil
        XCTAssert(testClass.getterSetterObject == nil)
    }
    
    func testCustomSourcedObject() {
        XCTAssertNil(testClass.customSourcedObject)
        testClass.customSourcedObject = 400
        XCTAssert(testClass.customSourcedObject == 400)
        testClass.customSourcedObject = nil
        XCTAssert(testClass.customSourcedObject == nil)
    }
//    
//    func testCustomSourcedKeyedObject() {
//        XCTAssertNil(testClass.customKeyedSourcedObject)
//        testClass.customKeyedSourcedObject = 900
//        XCTAssert(testClass.customKeyedSourcedObject == 900)
//        testClass.customKeyedSourcedObject = nil
//        XCTAssert(testClass.customKeyedSourcedObject == nil)
//    }
}
