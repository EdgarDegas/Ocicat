//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/24.
//

import Foundation
import SwiftSyntax

struct KeyArgumentsResolver {
    let variadicStringResolver: StringArgumentsResolver
    
    let keyDeclarations: [DeclSyntax]
    
    init(arguments: LabeledExprListSyntax) throws {
        variadicStringResolver = try StringArgumentsResolver(arguments: arguments)
        keyDeclarations = variadicStringResolver.nonNilStringArguments
            .map {
                "static var \(raw: $0): Void?"
            }
    }
}
