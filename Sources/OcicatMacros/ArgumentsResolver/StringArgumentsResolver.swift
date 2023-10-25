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
    enum Error: Swift.Error, CustomStringConvertible {
        case acceptOnlyStringLiterals(index: Int)
        case invalidArgument(index: Int)
        
        var description: String {
            switch self {
            case .acceptOnlyStringLiterals:
                "Accept only literal strings, not even references to String objects"
            case .invalidArgument:
                "Argument is invalid. Accept only contiguous, non-interpolated literal String objects"
            }
        }
    }
    
    let arguments: [String]
    
    init(arguments: LabeledExprListSyntax) throws {
        let expressions = try Self.getExpressions(of: arguments)
        self.arguments = try Self.getStrings(from: expressions)
    }
    
    static func getExpressions(
        of arguments: LabeledExprListSyntax
    ) throws -> [StringLiteralExprSyntax] {
        try ensureAllArgumentsAreStringLiteral(arguments)
        return arguments.map {
            $0.expression.as(StringLiteralExprSyntax.self)!
        }
        
        
        func ensureAllArgumentsAreStringLiteral(
            _ arguments: LabeledExprListSyntax
        ) throws {
            let nonStringIndex = arguments.firstIndex {
                !$0.expression.is(StringLiteralExprSyntax.self)
            }
            guard nonStringIndex == nil else {
                let index = arguments.distance(
                    from: arguments.startIndex,
                    to: nonStringIndex!
                )
                throw Error.acceptOnlyStringLiterals(index: index)
            }
        }
    }
    
    static func getStrings(
        from expressions: [StringLiteralExprSyntax]
    ) throws -> [String] {
        try ensureAllExpressionsHaveSingleSegment(expressions)
        let segments = expressions.map(\.segments.first!)
        return try convertToStringSegments(segments).map(\.content.text)
        

        func ensureAllExpressionsHaveSingleSegment(
            _ expressions: [StringLiteralExprSyntax]
        ) throws {
            let nonSingleSegmentedIndex = expressions.firstIndex {
                $0.segments.count != 1
            }
            guard nonSingleSegmentedIndex == nil else {
                throw Error.invalidArgument(index: nonSingleSegmentedIndex!)
            }
        }
        
        func convertToStringSegments(
            _ segments: [StringLiteralSegmentListSyntax.Element]
        ) throws -> [StringSegmentSyntax] {
            let segments = expressions.map(\.segments.first!)
            let nonLiteralIndex = segments.firstIndex {
                !$0.is(StringSegmentSyntax.self)
            }
            guard nonLiteralIndex == nil else {
                throw Error.invalidArgument(index: nonLiteralIndex!)
            }
            return segments.map {
                $0.as(StringSegmentSyntax.self)!
            }
        }
    }
}
