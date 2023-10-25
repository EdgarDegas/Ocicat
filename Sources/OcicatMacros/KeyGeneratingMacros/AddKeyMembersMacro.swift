//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AddKeyMembersMacro: MemberMacro, KeyGenerating {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            return []
        }
        
        return try getKeyDeclarations(from: arguments, in: context)
    }
}
