//
//  BuiderMacro.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/11.
//

import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros

public struct BuilderMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration is StructDeclSyntax else { throw CustomError.message("error: add annotation to struct") }
        
        var optionalVariables: [Variable] = []
        var nonOptionalvariables: [Variable] = []

        declaration.memberBlock.members.forEach { item in
            guard let variableDecl = item.decl.as(VariableDeclSyntax.self) else { return }
            
            variableDecl.bindings.forEach { binding in
                guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else { return }
                
                if let optionalType = binding.typeAnnotation?.type.as(OptionalTypeSyntax.self),
                   let wrappedType = optionalType.wrappedType.as(IdentifierTypeSyntax.self) {
                    let variable = Variable(
                        name: identifier.identifier.text,
                        type: wrappedType.name.text
                    )
                    optionalVariables.append(variable)
                } else if let type = binding.typeAnnotation?.type.as(IdentifierTypeSyntax.self) {
                    let variable = Variable(
                        name: identifier.identifier.text,
                        type: type.name.text
                    )
                    nonOptionalvariables.append(variable)
                }
            }
        }
        
        var returnList: [DeclSyntax] = []
        
        let initDecl: DeclSyntax = """
        init(
            \(
        raw: nonOptionalvariables.map { initVariable in
            "\(initVariable.name): \(initVariable.type)"
        }.joined(separator: ",")
            )
        ) {
            \(
        raw: nonOptionalvariables.map { initVariable in
            "self.\(initVariable.name) = \(initVariable.name)"
        }.joined(separator: ",")
            )
        }
        """
        
        returnList.append(initDecl)
        
        optionalVariables.forEach { setVariable in
            let setMethod: DeclSyntax = "mutating func set\(raw: setVariable.name)(value: \(raw: setVariable.type)) { self.\(raw: setVariable.name) = value }"
            
            returnList.append(setMethod)
        }
        
        return returnList
    }
    
    private struct Variable {
        let name: String
        let type: String
        
    }
}

enum CustomError: Error { case message(String) }

