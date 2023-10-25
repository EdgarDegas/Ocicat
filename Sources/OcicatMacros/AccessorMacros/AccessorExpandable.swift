//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/25.
//

import SwiftSyntax

fileprivate enum ArgumentLabel: String {
    case key
    case source
}

protocol AccessorExpandable {
    
}

extension AccessorExpandable {
    
    
    static func getKeyAndSource(from arguments: LabeledExprListSyntax) throws -> (String, String?) {
        let resolver = try StringArgumentsResolver(arguments: arguments)
        guard let key = resolver.argument(by: ArgumentLabel.key.rawValue) else {
            // guranteed by the compiler to have one and only one argument
            fatalError("Argument key missing")
        }
        let source = resolver.argument(by: ArgumentLabel.source.rawValue)
        return (key, source)
    }
}
