import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(OcicatMacros)
import OcicatMacros
import SwiftSyntax

enum TestMacro: CaseIterable {
    case ocicated
    case keys
    case addKeys
    case getter
    case setter
    case weakSetter
    
    var name: String {
        switch self {
        case .ocicated: return "Ocicated"
        case .keys: return "Keys"
        case .addKeys: return "AddKeys"
        case .getter: return "getter"
        case .setter: return "setter"
        case .weakSetter: return "weakSetter"
        }
    }
    
    var type: Macro.Type {
        switch self {
        case .ocicated:
            return AssociatedVariableMacro.self
        case .keys:
            return DeclareKeysMacro.self
        case .addKeys:
            return AddKeyMembersMacro.self
        case .getter:
            return GetterMacro.self
        case .setter:
            return SetterMacro.self
        case .weakSetter:
            return WeakSetterMacro.self
        }
    }
    
    static var testMacros: [String: Macro.Type] {
        let pairs = allCases.map {
            ($0.name, $0.type)
        }
        return .init(uniqueKeysWithValues: pairs)
    }
}

typealias SourceWithMacro = (String) -> String
typealias Source = () -> String

func assertMacroExpansion(
    _ macro: TestMacro,
    expandedSource: Source,
    originalSource: SourceWithMacro,
    diagnostics: [DiagnosticSpec] = [],
    testModuleName: String = "TestModule",
    testFileName: String = "test.swift",
    indentationWidth: Trivia = .spaces(4)
) {
    assertMacroExpansion(
        originalSource(macro.name),
        expandedSource: expandedSource(),
        diagnostics: diagnostics,
        macros: TestMacro.testMacros, 
        testModuleName: testModuleName,
        testFileName: testFileName,
        indentationWidth: indentationWidth
    )
}


typealias SourceWithMacros = ([String]) -> String
func assertMacroExpansion(
    _ macros: TestMacro...,
    expandedSource: Source,
    originalSource: SourceWithMacros,
    diagnostics: [DiagnosticSpec] = [],
    testModuleName: String = "TestModule",
    testFileName: String = "test.swift",
    indentationWidth: Trivia = .spaces(4)
) {
    assertMacroExpansion(
        originalSource(macros.map(\.name)),
        expandedSource: expandedSource(),
        diagnostics: diagnostics,
        macros: TestMacro.testMacros,
        testModuleName: testModuleName,
        testFileName: testFileName,
        indentationWidth: indentationWidth
    )
}

#endif
