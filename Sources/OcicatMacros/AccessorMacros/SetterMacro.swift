//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct SetterMacro: 
    ExpressionMacro,
    SetterExpandable
{
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let (value, key, source) = try setterValueKeySource(
            from: node.argumentList
        )
        let expr = setterExpression(
            value: value ?? setterNewValue,
            key: key,
            source: source ?? defaultSource
        )
        return "\(expr)"
    }
}
