import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct OcicatPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AccessorAndKeyMacro.self,
        DeclareKeysMacro.self,
        AddKeyMembersMacro.self
    ]
}
