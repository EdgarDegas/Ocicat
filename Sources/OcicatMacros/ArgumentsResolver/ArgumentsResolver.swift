//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

struct LabeledArgumentsResolver {
    struct LabeledArgument {
        let label: String?
        let value: ExprSyntax?
    }
    
    let arguments: [LabeledArgument]
    
    func argument(by label: String) -> ExprSyntax? {
        arguments.first { $0.label == label }?.value
    }
    
    init(arguments rawArguments: LabeledExprListSyntax) throws {
        arguments = try rawArguments.indices.map {
            try Self.resolveArgument(at: $0, in: rawArguments)
        }
    }
    
    static func resolveArgument(
        at index: SyntaxChildrenIndex,
        in rawArguments: LabeledExprListSyntax
    ) throws -> LabeledArgument {
        let expression = rawArguments[index].expression
        let label = rawArguments[index].label?.text
        if expressionIsNil() {
            return LabeledArgument(label: label, value: nil)
        } else {
            return LabeledArgument(
                label: label, value: expression
            )
        }
        
        func expressionIsNil() -> Bool {
            expression.is(NilLiteralExprSyntax.self)
        }
    }
    
    static func getString(
        from expression: StringLiteralExprSyntax
    ) -> String? {
        guard expression.segments.count == 1 else {
            return nil
        }
        let segment = expression.segments.first!
        return segment.as(StringSegmentSyntax.self)?.content.text
    }
}
