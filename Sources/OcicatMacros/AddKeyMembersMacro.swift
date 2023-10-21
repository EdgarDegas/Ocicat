//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AddKeyMembersMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            return []
        }
        
        typealias ArgumentsError = VariadicStringArgumentsResolver.Error
        do {
            let resolver = try VariadicStringArgumentsResolver(arguments: arguments)
            return resolver.memberDeclarations
        } catch ArgumentsError.acceptOnlyStringLiterals(let index) {
            let error = ArgumentsError.acceptOnlyStringLiterals(index: index)
            context.addDiagnostics(from: error, node: arguments[index])
            return []
        } catch {
            throw error
        }
    }
}
