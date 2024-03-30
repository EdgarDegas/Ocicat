//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/24.
//

import Foundation
import SwiftSyntax

struct VariadicArgumentsResolver {
    let variadicStringResolver: LabeledArgumentsResolver
    
    let keyDeclarations: [DeclSyntax]
    
    init(arguments: LabeledExprListSyntax) throws {
        variadicStringResolver = try LabeledArgumentsResolver(arguments: arguments)
        keyDeclarations = variadicStringResolver.arguments
            .compactMap {
                $0.value
            }
            .compactMap {
                $0.as(StringLiteralExprSyntax.self)
            }
            .map {
                "static var \($0.segments): Void?"
            }
    }
}
