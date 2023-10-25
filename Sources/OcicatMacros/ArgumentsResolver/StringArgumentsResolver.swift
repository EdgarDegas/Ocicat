//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

struct StringArgumentsResolver {
    struct Error: Swift.Error, CustomStringConvertible {
        let index: SyntaxChildrenIndex
        
        var description: String {
            "Argument is invalid. Accept only contiguous, non-interpolated literal String objects"
        }
    }
    
    struct LabeledArgument {
        let label: String?
        let value: String?
    }
    
    var nonNilStringArguments: [String] {
        arguments.compactMap {
            $0.value
        }
    }
    
    var stringArguments: [String?] {
        arguments.map(\.value)
    }
    
    let arguments: [LabeledArgument]
    
    func argument(by label: String) -> String? {
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
        } else if let string = try getString() {
            return LabeledArgument(label: label, value: string)
        } else {
            throw Error(index: index)
        }
        
        
        func expressionIsNil() -> Bool {
            expression.is(NilLiteralExprSyntax.self)
        }
        
        func getString() throws -> String? {
            if let expression = expression.as(StringLiteralExprSyntax.self) {
                if let string = Self.getString(from: expression) {
                    return string
                } else {
                    throw Error(index: index)
                }
            } else {
                return nil
            }
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
