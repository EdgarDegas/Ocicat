//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

protocol KeyGenerating {
}


extension KeyGenerating {
    static func getKeyDeclarations(
        from arguments: LabeledExprListSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        do {
            let resolver = try KeyArgumentsResolver(arguments: arguments)
            return resolver.keyDeclarations
        } catch let error as StringArgumentsResolver.Error {
            context.addDiagnostics(from: error, node: arguments[error.index])
            return []
        } catch {
            fatalError()
        }
    }
}
