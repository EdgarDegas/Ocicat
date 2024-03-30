import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


final class MacroTests: XCTestCase {
    func testOptionalVariable() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            var object: Int? {
                get {
                    ObjcWrapper.get(from: self, by: &Self.keyToObject) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: self, by: &Self.keyToObject)
                }
            }
            
            fileprivate static var keyToObject: Void?
            """
        } originalSource: {
            """
            @\($0)
            var object: Int?
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testNonOptionalVariable() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            var nonOptional: Int = 1 {
                get {
                    (ObjcWrapper.get(from: self, by: &Self.keyToNonOptional) ?? 1) as! Int
                }
                set {
                    ObjcWrapper.save(newValue, into: self, by: &Self.keyToNonOptional)
                }
            }
            
            fileprivate static var keyToNonOptional: Void?
            """
        } originalSource: {
            """
            @\($0)
            var nonOptional: Int = 1
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testUnwrappedObject() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) { """
            var unwrappedObject: Int! {
                get {
                    ObjcWrapper.get(from: self, by: &Self.keyToUnwrappedObject) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: self, by: &Self.keyToUnwrappedObject)
                }
            }
            
            fileprivate static var keyToUnwrappedObject: Void?
            """
        } originalSource: {
            """
            @\($0)
            var unwrappedObject: Int!
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testWeakObject() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            weak var weakRef: NSObject? {
                get {
                    ObjcWrapper.get(from: self, by: &Self.keyToWeakRef) as? NSObject
                }
                set {
                    ObjcWrapper.saveWeakReference(to: newValue, into: self, by: &Self.keyToWeakRef)
                }
            }
            
            fileprivate static var keyToWeakRef: Void?
            """
        } originalSource: {
            """
            @\($0)
            weak var weakRef: NSObject?
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testGetter() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.getter) {
            """
            ObjcWrapper.get(from: self, by: &theKey1)
            """
        } originalSource: {
            """
            #\($0)(by: theKey1)
            """
        }
        
        assertMacroExpansion(.getter) {
            """
            ObjcWrapper.get(from: anotherInstance, by: &theKey11)
            """
        } originalSource: {
            """
            #\($0)(from: anotherInstance, by: theKey11)
            """
        }

        #else
        throw XCTSkip()
        #endif
    }
    
    func testSetter() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.setter) {
            """
            ObjcWrapper.save(newValue, into: self, by: &theKey2)
            """
        } originalSource: {
            """
            #\($0)(newValue, by: theKey2)
            
            """
        }
        
        assertMacroExpansion(.setter) {
            """
            ObjcWrapper.save(newValue, into: theSource2, by: &theKey22)
            """
        } originalSource: {
            """
            #\($0)(to: theSource2, by: theKey22)
            """
        }

        #else
        throw XCTSkip()
        #endif
    }
    
    func testWeakSetter() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.weakSetter) {
            """
            ObjcWrapper.saveWeakReference(to: newValue, into: self, by: &theKey3)
            """
        } originalSource: {
            """
            #\($0)(by: theKey3)
            """
        }
        
        assertMacroExpansion(.weakSetter) {
            """
            ObjcWrapper.saveWeakReference(to: newValue, into: theSource3, by: &theKey33)
            """
        } originalSource: {
            """
            #\($0)(to: theSource3, by: theKey33)
            """
        }

        #else
        throw XCTSkip()
        #endif
    }
}
