//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct GetterMacro: ExpressionMacro, AccessorExpandable {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let (key, source) = try getKeyAndSource(from: node.argumentList)
        return "\(raw: getterExpression(key: key, source: source ?? defaultSource))"
    }
}
