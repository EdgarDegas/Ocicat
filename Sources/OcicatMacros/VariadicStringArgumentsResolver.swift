//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/20.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

struct VariadicStringArgumentsResolver {
    enum Error: Swift.Error, CustomStringConvertible {
        case acceptOnlyStringLiterals(index: SyntaxChildrenIndex)
        
        var description: String {
            switch self {
            case .acceptOnlyStringLiterals:
                "Accept only literal strings, not references to String objects"
            }
        }
    }
    
    private let expressions: [ExprSyntax]
    
    var memberDeclarations: [DeclSyntax] {
        expressions
            .compactMap {
                $0.as(StringLiteralExprSyntax.self)?.segments.first
            }
            .compactMap {
                $0.as(StringSegmentSyntax.self)?.content
            }
            .compactMap {
                "static var \($0): Void?"
            }
    }
    
    init(arguments: LabeledExprListSyntax) throws {
        expressions = try Self.getExpressions(of: arguments)
    }
    
    static func getExpressions(of arguments: LabeledExprListSyntax) throws -> [ExprSyntax] {
        let nonStringIndex = arguments.firstIndex {
            !$0.expression.is(StringLiteralExprSyntax.self)
        }
        guard nonStringIndex == nil else {
            throw Error.acceptOnlyStringLiterals(index: nonStringIndex!)
        }
        return arguments.map(\.expression)
    }
}
