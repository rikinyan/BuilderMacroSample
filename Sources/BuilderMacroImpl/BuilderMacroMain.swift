//
//  BuilderMacroMain.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/13.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct BuilderMacroMain: CompilerPlugin {
    var providingMacros: [Macro.Type] = [BuilderMacro.self]
}
