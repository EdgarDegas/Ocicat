//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct SetterMacro: ExpressionMacro, AccessorExpandable {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let key = try getKey(from: node.argumentList)
        return "\(raw: setterExpression(key: key, source: defaultSource))"
    }
}
