//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax

protocol AccessorExpandable {
    
}

extension AccessorExpandable {
    static func getKeyName(from arguments: LabeledExprListSyntax) throws -> String {
        let resolver = try StringArgumentsResolver(arguments: arguments)
        guard let keyName = resolver.nonNilStringArguments.first else {
            // guranteed by the compiler to have one and only one argument
            fatalError("Argument key name missing")
        }
        return keyName
    }
}
