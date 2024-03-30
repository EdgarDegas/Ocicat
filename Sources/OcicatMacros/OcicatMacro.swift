import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct OcicatPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssociatedVariableMacro.self,
        GetterMacro.self,
        SetterMacro.self
    ]
}

func getterExpression(key: ExprSyntax, source: ExprSyntax) -> ExprSyntax {
    "ObjcWrapper.get(from: \(source), by: &\(key))"
}

func setterExpression(value: ExprSyntax, key: ExprSyntax, source: ExprSyntax) -> ExprSyntax {
    "ObjcWrapper.save(\(value), into: \(source), by: &\(key))"
}

func weakSetterExpression(value: ExprSyntax, key: ExprSyntax, source: ExprSyntax) -> ExprSyntax {
    "ObjcWrapper.saveWeakReference(to: \(value), into: \(source), by: &\(key))"
}

var defaultSource: ExprSyntax {
    "self"
}

var setterNewValue: ExprSyntax {
    "newValue"
}
