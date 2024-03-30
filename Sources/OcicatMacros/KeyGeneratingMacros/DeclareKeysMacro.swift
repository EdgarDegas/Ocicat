//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct DeclareKeysMacro: DeclarationMacro, KeyGenerating {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let argumentList = node.argumentList
        let declarations = try getKeyDeclarations(
            from: argumentList,
            in: context
        )
        if declarations.isEmpty {
            return []
        } else {
            return formatedDeclarations(with: declarations)
        }
    }
    
    static func formatedDeclarations(with memberDeclarations: [DeclSyntax]) -> [DeclSyntax] {
        let memberDeclarations = memberDeclarations
            .map {
                "\($0)"
            }
            .joined(separator: "\n")
        
        return [
            """
            enum Keys {
                \(raw: memberDeclarations)
            }
            """
        ]
    }
}
