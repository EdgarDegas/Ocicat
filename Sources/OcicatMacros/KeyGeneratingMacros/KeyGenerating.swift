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
            let resolver = try KeyNameArgumentsResolver(arguments: arguments)
            return resolver.keyNameDeclarations
        } catch let error as StringArgumentsResolver.Error {
            diagnoseArgumentsError(error, among: arguments, in: context)
            return []
        } catch {
            fatalError()
        }
    }
    
    static func diagnoseArgumentsError(
        _ error: StringArgumentsResolver.Error,
        among arguments: LabeledExprListSyntax,
        in context: some MacroExpansionContext
    ) {
        let index = arguments.index(
            arguments.startIndex,
            offsetBy: error.index
        )
        context.addDiagnostics(from: error, node: arguments[index])
    }
}
