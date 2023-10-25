// The Swift Programming Language
// https://docs.swift.org/swift-book


@attached(accessor)
@attached(peer, names: arbitrary)
public macro Ocicated(
    source: StringLiteralType? = nil,
    key: StringLiteralType? = nil
) = #externalMacro(
    module: "OcicatMacros", type: "AssociatedVariableMacro"
)

@attached(accessor)
@attached(peer, names: arbitrary)
public macro Ocicated() = #externalMacro(
    module: "OcicatMacros", type: "AssociatedVariableMacro"
)

@freestanding(declaration, names: named(Keys))
public macro Keys(_: StringLiteralType...) = #externalMacro(
    module: "OcicatMacros", type: "DeclareKeysMacro"
)

@attached(member, names: arbitrary)
public macro AddKeys(_: StringLiteralType...) = #externalMacro(
    module: "OcicatMacros", type: "AddKeyMembersMacro"
)

@freestanding(expression)
public macro getter(by key: StringLiteralType) = #externalMacro(
    module: "OcicatMacros", type: "GetterMacro"
)


@freestanding(expression)
public macro setter(by key: StringLiteralType) = #externalMacro(
    module: "OcicatMacros", type: "SetterMacro"
)

@freestanding(expression)
public macro weakSetter(by key: StringLiteralType) = #externalMacro(
    module: "OcicatMacros", type: "WeakSetterMacro"
)
