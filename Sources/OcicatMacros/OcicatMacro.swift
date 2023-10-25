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

func getterExpression(by keyName: String) -> String {
    "ObjcWrapper.get(from: self, by: &\(keyName))"
}

func setterExpression(by keyName: String) -> String {
    "ObjcWrapper.save(newValue, into: self, by: &\(keyName))"
}

func weakSetterExpression(by keyName: String) -> String {
    "ObjcWrapper.saveWeakReference(to: newValue, into: self, by: &\(keyName))"
}
