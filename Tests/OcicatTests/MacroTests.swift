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
    
    func testCustomKeyedObject() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            var customKeyedObject: Int? {
                get {
                    ObjcWrapper.get(from: self, by: &customKey) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: self, by: &customKey)
                }
            }
            """
        } originalSource: {
            """
            @\($0)(keyName: "customKey")
            var customKeyedObject: Int?
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testCustomSourcedObject() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            var customSourcedObject: Int? {
                get {
                    ObjcWrapper.get(from: notSelf, by: &Self.keyToCustomSourcedObject) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: notSelf, by: &Self.keyToCustomSourcedObject)
                }
            }
            
            fileprivate static var keyToCustomSourcedObject: Void?
            """
        } originalSource: {
            """
            @\($0)(source: "notSelf")
            var customSourcedObject: Int?
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testCustomSourcedCustomKeyedObject() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.ocicated) {
            """
            var customizedObject: Int? {
                get {
                    ObjcWrapper.get(from: customSource, by: &customKey) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: customSource, by: &customKey)
                }
            }
            """
        } originalSource: {
            """
            @\($0)(source: "customSource", keyName: "customKey")
            var customizedObject: Int?
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testKeys() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.keys) {
            """
            struct Keys {
                static var one: Void?
                static var two: Void?
            }
            """
        } originalSource: {
            """
            #\($0)("one", "two")
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testKeysWithInvalidArguments() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.keys, expandedSource: {
            """
            let key = "two"
            """
        }, originalSource: {
            """
            let key = "two"
            #\($0)("one", key)
            """
        }, diagnostics: [
            DiagnosticSpec(
                message: "Argument is invalid. Accept only contiguous, non-interpolated literal String objects",
                line: 2,
                column: 14
            )
        ]
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
    
    func testAddingKeys() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(.addKeys) {
            """
            struct MyKeys {
            
                static var k1: Void?
            
                static var k2: Void?
            
            }
            """
        } originalSource: {
            """
            @\($0)("k1", "k2")
            struct MyKeys {
            
            }
            """
        }
        
        assertMacroExpansion(.addKeys) {
            """
            struct MyKeys {
            
            }
            """
        } originalSource: {
            """
            @\($0)()
            struct MyKeys {
            
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testAddingKeysWithInvalidArguments() throws {
    #if canImport(OcicatMacros)
        assertMacroExpansion(.addKeys, expandedSource: {
            """
            let key = "two"
            struct MyKeys {
            
            }
            """
        }, originalSource: {
            """
            let key = "two"
            @\($0)("k1", key)
            struct MyKeys {
            
            }
            """
        }, diagnostics: [
            DiagnosticSpec(
                message: "Argument is invalid. Accept only contiguous, non-interpolated literal String objects",
                line: 2,
                column: 16
            )
        ]
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
    
    func testCustomKeysInKeys() throws {
        #if canImport(OcicatMacros)
        assertMacroExpansion(
            .keys, .ocicated
        ) {
            """
            struct Keys {
                static var one: Void?
                static var two: Void?
            }
            var customKeyedObject: Int? {
                get {
                    ObjcWrapper.get(from: self, by: &Keys.one) as? Int
                }
                set {
                    ObjcWrapper.save(newValue, into: self, by: &Keys.one)
                }
            }
            """
        } originalSource: {
            """
            #\($0[0])("one", "two")
            
            @\($0[1])(keyName: "Keys.one")
            var customKeyedObject: Int?
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
            #\($0)(by: "theKey1")
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
            #\($0)(by: "theKey2")
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
            #\($0)(by: "theKey3")
            """
        }

        #else
        throw XCTSkip()
        #endif
    }
}
