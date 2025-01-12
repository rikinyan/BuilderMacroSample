//
//  BuilderMacroDeclaration.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/11.
//

@attached(member, names: named(`init`), arbitrary)
public macro Builder() = #externalMacro(module: "MyExexutable", type: "BuilderMacro")
