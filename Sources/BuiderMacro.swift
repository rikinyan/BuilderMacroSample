//
//  BuiderMacro.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/11.
//

import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros

struct BuilderMacro: MemberMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration as? StructDeclSyntax else { throw CustomError.message("error: add annotation to struct") }
        
        var optionalVariables: [Variable] = []
        var nonOptionalvariables: [Variable] = []

        declaration.memberBlock.members.forEach { item in
            guard let variableDecl = item.as(VariableDeclSyntax.self) else { return }
            
            variableDecl.bindings.forEach { binding in
                guard let identifier = binding.pattern.as(IdentifierTypeSyntax.self) else { return }
                
                if let optionalType = binding.typeAnnotation?.type.as(OptionalTypeSyntax.self),
                   let wrappedType = optionalType.wrappedType.as(IdentifierTypeSyntax.self) {
                    let variable = Variable(
                        name: identifier.name.text,
                        type: wrappedType.name.text
                    )
                    optionalVariables.append(variable)
                } else if let type = binding.typeAnnotation?.type.as(IdentifierTypeSyntax.self) {
                    let variable = Variable(
                        name: identifier.name.text,
                        type: type.name.text
                    )
                    nonOptionalvariables.append(variable)
                }
            }
        }
        
        
        var initSignature = FunctionParameterListSyntax()
        nonOptionalvariables.forEach { variable in
            initSignature.append(FunctionParameterSyntax(stringLiteral: "\(variable.name): \(variable.type)"))
        }
        var initBindings = CodeBlockItemListSyntax()
        nonOptionalvariables.forEach { variable in
            initBindings.append(CodeBlockItemSyntax(stringLiteral: "self.\(variable.name) = \(variable.name)"))
        }
        
        let initDecl = InitializerDeclSyntax(
            signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: initSignature)),
            body: CodeBlockSyntax(statements: initBindings)
        )
        
        let setMethodsDecls = optionalVariables.map { setVariable in
            FunctionDeclSyntax(
                name: TokenSyntax(stringLiteral: "set\(setVariable.name)"),
                signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: [])),
                body: CodeBlockSyntax(statements: [CodeBlockItemSyntax(stringLiteral: "self.\(setVariable.name) = \(setVariable.name)")])
            )
        }
    
        var returnList: [DeclSyntax] = []
        
        returnList.append(initDecl)
        setMethodsDecls.forEach { returnList.append($0) }
        
        return returnList
    }
    
    
    struct Variable {
        let name: String
        let type: String
    }
    
}

enum CustomError: Error { case message(String) }

