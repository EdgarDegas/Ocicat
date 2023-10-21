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
    
    func testCustomKeyedObject() {
        XCTAssertNil(testClass.customKeyedObject)
        
        let value = 54
        testClass.customKeyedObject = value
        XCTAssertEqual(testClass.customKeyedObject, value)
        
        testClass.customKeyedObject = nil
        XCTAssertNil(testClass.customKeyedObject)
    }
}
