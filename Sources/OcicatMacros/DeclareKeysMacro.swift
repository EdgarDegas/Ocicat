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
        typealias ArgumentsError = StringArgumentsResolver.Error
        do {
            let resolver = try KeyNameArgumentsResolver(arguments: node.argumentList)
            return formatedDeclarations(with: resolver.keyNameDeclarations)
        } catch let error as ArgumentsError {
            switch error {
            case .acceptOnlyStringLiterals(let offset),
                 .invalidArgument(let offset)
            :
                let argumentList = node.argumentList
                let index = argumentList.index(
                    argumentList.startIndex,
                    offsetBy: offset
                )
                context.addDiagnostics(from: error, node: argumentList[index])
                return []
            }
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
