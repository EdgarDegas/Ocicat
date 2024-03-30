// The Swift Programming Language
// https://docs.swift.org/swift-book


@attached(accessor)
@attached(peer, names: arbitrary)
public macro Ocicated() = #externalMacro(
    module: "OcicatMacros", type: "AssociatedVariableMacro"
)

@freestanding(expression)
public macro get(from source: Any? = nil, by key: Key) -> Any? = #externalMacro(
    module: "OcicatMacros", type: "GetterMacro"
)

@freestanding(expression)
public macro set(_ value: Any? = nil, to source: Any? = nil, by key: Key) = #externalMacro(
    module: "OcicatMacros", type: "SetterMacro"
)

@freestanding(expression)
public macro weaklySet(_ value: Any, to source: Any? = nil, by key: Key) = #externalMacro(
    module: "OcicatMacros", type: "WeakSetterMacro"
)
