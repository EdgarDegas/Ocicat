//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/19.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AssociatedVariableMacro: PeerMacro, AccessorMacro {
    public enum Error: Swift.Error, CustomStringConvertible {
        case onlyApplicableToVariables
        case failedToFindPatternBinding
        case patternBindingNotIdentifiable
        case mustHasTypeAnnotation
        case nonOptionalVariableMustHaveADefaultValue
        case initialzedButOptional
        case invalidCustomKey
        
        public var description: String {
            switch self {
            case .onlyApplicableToVariables:
                return "Can only be applied to variables."
            case .failedToFindPatternBinding:
                return "Cannot find pattern binding."
            case .patternBindingNotIdentifiable:
                return "Pattern binding is not an IdentifierPatternSyntax."
            case .mustHasTypeAnnotation:
                return "Must declare the type of the variable explicitly."
            case .nonOptionalVariableMustHaveADefaultValue:
                return "You must initialize non-optional variables to provide them with a default value."
            case .initialzedButOptional:
                return "You should not initialize a variable that's optional. Use non-optional to have a default value."
            case .invalidCustomKey:
                return "Custom key should be contiguous."
            }
        }
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let argumentResolver = try ArgumentResolver(node: node)
        if argumentResolver.keyName != nil {
            return []
        } else {
            let resolver = try Resolver(
                declaration: declaration, 
                customKeyName: nil,
                customSource: nil
            )
            return ["fileprivate static var \(raw: resolver.keyName): Void?"]
        }
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        let argumentResolver = try ArgumentResolver(node: node)
        let resolver = try Resolver(
            declaration: declaration,
            customKeyName: argumentResolver.keyName,
            customSource: argumentResolver.source
        )
        return [
            """
            get {
                \(raw: resolver.getter)
            }
            set {
                \(raw: resolver.setter)
            }
            """
        ]
    }
    
    struct ArgumentResolver {
        enum ArgumentLabel: String {
            case keyName
            case source
        }
        
        let keyName: String?
        let source: String?
        
        init(node: AttributeSyntax) throws {
            guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
                keyName = nil
                source = nil
                return
            }
            let stringArgumentsResolver = try StringArgumentsResolver(
                arguments: arguments
            )
            keyName = stringArgumentsResolver.argument(by: ArgumentLabel.keyName.rawValue)
            source = stringArgumentsResolver.argument(by: ArgumentLabel.source.rawValue)
        }
        
        static func getKeyName(from segments: StringLiteralSegmentListSyntax) -> TokenSyntax? {
            segments.first?.as(StringSegmentSyntax.self)?.content
        }
    }
    
    struct Resolver {
        let declaration: VariableDeclSyntax
        let binding: PatternBindingSyntax
        let variableName: String
        let typeAnnotation: TypeAnnotationSyntax
        let customKeyName: String?
        let source: String
        
        var defaultValue: ExprSyntax?
        
        var keyName: String {
            let variableName = variableName
            return "keyTo\(variableName.first!.uppercased())\(variableName.dropFirst())"
        }
        
        var key: String {
            if let customKeyName = customKeyName {
                return customKeyName
            } else {
                return "Self.\(keyName)"
            }
        }
        
        var type: TypeSyntax {
            typeAnnotation.type
        }
        
        var isOptional: Bool {
            type.is(OptionalTypeSyntax.self)
        }
        
        var isImplicitlyUnwrapped: Bool {
            type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self)
        }
        
        var wrappedType: TypeSyntax {
            if let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType {
                return wrappedType
            } else if let wrappedType = type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self)?.wrappedType {
                return wrappedType
            } else {
                return type
            }
        }
        
        var isWeak: Bool {
            declaration.modifiers.contains {
                $0.name.tokenKind == TokenSyntax.keyword(.weak).tokenKind
            }
        }
        
        var getter: String {
            let getter = getterExpression(keyName: key, source: source)
            if isOptional || isImplicitlyUnwrapped {
                return "\(getter) as? \(wrappedType)"
            } else {
                return "(\(getter) ?? \(defaultValue!)) as! \(wrappedType)"
            }
        }
        
        var setter: String {
            if isWeak {
                return weakSetterExpression(keyName: key, source: source)
            } else {
                return setterExpression(keyName: key, source: source)
            }
        }
        
        init(
            declaration: some DeclSyntaxProtocol,
            customKeyName: String?,
            customSource: String?
        ) throws {
            self.customKeyName = customKeyName
            self.source = customSource ?? defaultSource
            
            guard let declaration = declaration.as(VariableDeclSyntax.self) else {
                throw Error.onlyApplicableToVariables
            }
            self.declaration = declaration
            
            binding = try Self.getBinding(from: declaration)
            variableName = try Self.getNameOfVariable(from: binding)
            typeAnnotation = try Self.getTypeAnnotation(from: binding)
            defaultValue = binding.initializer?.value
            
            if shouldHaveDefaultValue {
                guard defaultValue != nil else {
                    throw Error.nonOptionalVariableMustHaveADefaultValue
                }
            } else {
                guard defaultValue == nil else {
                    throw Error.initialzedButOptional
                }
            }
        }
        
        private var shouldHaveDefaultValue: Bool {
            if isOptional {
                // optionals should never have any default value
                return false
            }
            if isImplicitlyUnwrapped {
                // implicityly unwrapped values should crash when it returns `nil`, instead of having a default value
                return false
            }
            // non-optional variables should at least default to something
            return true
        }
        
        static func getTypeAnnotation(from binding: PatternBindingSyntax) throws -> TypeAnnotationSyntax {
            guard let typeAnnotation = binding.typeAnnotation else {
                throw Error.mustHasTypeAnnotation
            }
            return typeAnnotation
        }
        
        static func getBinding(from declaration: VariableDeclSyntax) throws -> PatternBindingSyntax {
            guard let binding = declaration.bindings.first else {
                throw Error.failedToFindPatternBinding
            }
            return binding
        }
        
        static func getNameOfVariable(from binding: PatternBindingSyntax) throws -> String {
            guard let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
                throw Error.patternBindingNotIdentifiable
            }
            return name.text
        }
    }
}
