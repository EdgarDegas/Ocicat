import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct OcicatPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssociatedVariableMacro.self,
        DeclareKeysMacro.self,
        AddKeyMembersMacro.self
    ]
}

func getterExpression(keyName: String, source: String) -> String {
    "ObjcWrapper.get(from: \(source), by: &\(keyName))"
}

func setterExpression(keyName: String, source: String) -> String {
    "ObjcWrapper.save(newValue, into: \(source), by: &\(keyName))"
}

func weakSetterExpression(keyName: String, source: String) -> String {
    "ObjcWrapper.saveWeakReference(to: newValue, into: \(source), by: &\(keyName))"
}

var defaultSource: String {
    "self"
}
