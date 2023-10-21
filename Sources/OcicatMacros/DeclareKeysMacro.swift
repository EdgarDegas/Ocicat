//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct DeclareKeysMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        typealias ArgumentsError = VariadicStringArgumentsResolver.Error
        do {
            let resolver = try VariadicStringArgumentsResolver(arguments: node.argumentList)
            return formatedDeclarations(with: resolver.memberDeclarations)
        } catch ArgumentsError.acceptOnlyStringLiterals(let index) {
            let error = ArgumentsError.acceptOnlyStringLiterals(index: index)
            context.addDiagnostics(from: error, node: node.argumentList[index])
            return []
        } catch {
            throw error
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
            struct Keys {
                \(raw: memberDeclarations)
            }
            """
        ]
    }
}
