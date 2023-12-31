// The Swift Programming Language
// https://docs.swift.org/swift-book


@attached(accessor)
@attached(peer, names: arbitrary)
public macro Ocicated(keyName: StringLiteralType? = nil) = #externalMacro(
    module: "OcicatMacros", type: "AccessorAndKeyMacro"
)

@attached(accessor)
@attached(peer, names: arbitrary)
public macro Ocicated() = #externalMacro(
    module: "OcicatMacros", type: "AccessorAndKeyMacro"
)

@freestanding(declaration, names: named(Keys))
public macro Keys(_: StringLiteralType...) = #externalMacro(
    module: "OcicatMacros", type: "DeclareKeysMacro"
)

@attached(member, names: arbitrary)
public macro AddKeys(_: StringLiteralType...) = #externalMacro(
    module: "OcicatMacros", type: "AddKeyMembersMacro"
)
