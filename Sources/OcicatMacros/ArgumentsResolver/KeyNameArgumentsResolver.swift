//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/24.
//

import Foundation
import SwiftSyntax

struct KeyNameArgumentsResolver {
    let variadicStringResolver: StringArgumentsResolver
    
    let keyNameDeclarations: [DeclSyntax]
    
    init(arguments: LabeledExprListSyntax) throws {
        variadicStringResolver = try StringArgumentsResolver(arguments: arguments)
        keyNameDeclarations = variadicStringResolver.arguments
            .map {
                "static var \(raw: $0): Void?"
            }
    }
}
