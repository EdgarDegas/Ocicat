//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax

enum SetterArgumentLabel: String {
    case key = "by"
    case source = "to"
}

enum GetterArgumentLabel: String {
    case key = "by"
    case source = "from"
}

enum AccessorMacroError:
    Swift.Error,
    CustomStringConvertible
{
    var description: String {
        switch self {
        case .missingKey:
            "Missing parameter: key"
        }
    }
    
    case missingKey
}

protocol SetterExpandable {
    
}

extension SetterExpandable {
    typealias Error = AccessorMacroError
    
    static func getterKeySource(
        from arguments: LabeledExprListSyntax
    ) throws -> (ExprSyntax, ExprSyntax?) {
        typealias Label = GetterArgumentLabel
        let arguments = try LabeledArgumentsResolver(
            arguments: arguments
        )
        guard let key = arguments.argument(
            by: Label.key.rawValue
        ) else {
            throw Error.missingKey
        }
        return (key, arguments.argument(by: Label.source.rawValue))
    }
    
    static func setterValueKeySource(
        from arguments: LabeledExprListSyntax
    ) throws -> (ExprSyntax?, ExprSyntax, ExprSyntax?) {
        typealias Label = SetterArgumentLabel
        let arguments = try LabeledArgumentsResolver(
            arguments: arguments
        )
        guard let key = arguments.argument(
            by: Label.key.rawValue
        ) else {
            throw Error.missingKey
        }
        if arguments.arguments.count == 3 {
            return (
                arguments.arguments[0].value,
                key,
                arguments.argument(by: Label.source.rawValue)
            )
        } else {
            return (
                nil,
                key,
                arguments.argument(by: Label.source.rawValue)
            )
        }
    }
}
