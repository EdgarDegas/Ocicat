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
    static func getKey(from arguments: LabeledExprListSyntax) throws -> String {
        let resolver = try StringArgumentsResolver(arguments: arguments)
        guard let key = resolver.nonNilStringArguments.first else {
            // guranteed by the compiler to have one and only one argument
            fatalError("Argument key missing")
        }
        return key
    }
}
