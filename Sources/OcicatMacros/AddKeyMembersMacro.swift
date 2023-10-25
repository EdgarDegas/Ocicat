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
        
        typealias ArgumentsError = StringArgumentsResolver.Error
        do {
            let resolver = try KeyNameArgumentsResolver(arguments: arguments)
            return resolver.keyNameDeclarations
        } catch let error as ArgumentsError {
            switch error {
            case .acceptOnlyStringLiterals(let offset),
                 .invalidArgument(let offset)
            :
                let index = arguments.index(arguments.startIndex, offsetBy: offset)
                context.addDiagnostics(from: error, node: arguments[index])
                return []
            }
        } catch {
            throw error
        }
    }
}
