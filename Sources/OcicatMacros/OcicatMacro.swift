import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct OcicatPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssociatedVariableMacro.self,
        DeclareKeysMacro.self,
        AddKeyMembersMacro.self,
        GetterMacro.self,
        SetterMacro.self
    ]
}

func getterExpression(key: String, source: String) -> String {
    "ObjcWrapper.get(from: \(source), by: &\(key))"
}

func setterExpression(key: String, source: String) -> String {
    "ObjcWrapper.save(newValue, into: \(source), by: &\(key))"
}

func weakSetterExpression(key: String, source: String) -> String {
    "ObjcWrapper.saveWeakReference(to: newValue, into: \(source), by: &\(key))"
}

var defaultSource: String {
    "self"
}
