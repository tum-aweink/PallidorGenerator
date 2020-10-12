//
//  PrimitiveTypeResolver.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Resolves primitive types defined in open api document
/// e.g. for object properties or method parameters
struct PrimitiveTypeResolver {
    
    
    /// Resolves Strings with special formats
    /// - Parameter context: string context
    /// - Returns: type as String
    static func resolveTypeFormat(context: JSONSchema.CoreContext<JSONTypeFormat.StringFormat>) -> String {
        context.format.rawValue.isEmpty ? "String" : ( context.format.rawValue == "date-time" || context.format.rawValue == "date" ? "Date" : "String")
    }
    
    /// Resolves Integer with special formats
    /// - Parameter context: integer context
    /// - Returns: type as String
    static func resolveTypeFormat(context: JSONSchema.CoreContext<JSONTypeFormat.IntegerFormat>) -> String {
        context.format.rawValue.isEmpty ? "Int" : context.format.rawValue.capitalized
    }
    
    /// Resolves Number with special formats
    /// - Parameter context: number context
    /// - Returns: type as String
    static func resolveTypeFormat(context: JSONSchema.CoreContext<JSONTypeFormat.NumberFormat>) -> String {
        context.format.rawValue.isEmpty ? "Double" : context.format.rawValue.capitalized
    }
    
    
    /// Resolves primitive types defined in open api document
    /// - Parameter schema: schema to check
    /// - Throws: error if type cannot be resolved
    /// - Returns: type as String
    static func resolveTypeFormat(schema: JSONSchema) throws -> String {
        switch schema {
        case .boolean(_):
            return "Bool"
        case .number(let context, _):
            return resolveTypeFormat(context: context)
        case .integer(let context, _):
            return resolveTypeFormat(context: context)
        case .string(let context, _):
            return resolveTypeFormat(context: context)
        case .array(_, _):
            return ArrayResolver.resolveArrayItemType(schema: schema)
        case .reference(_):
            return try ReferenceResolver.resolveName(schema: schema)
        case .object(_, let objectContext):
            guard let props = objectContext.additionalProperties else {
                throw ResolvementError.NotSupported(msg: "No nested objects as primitives supported")
            }
            
            if let schema = props.b {
                let propType = try resolveTypeFormat(schema: schema)
                return "[String:\(propType)]"
            }
        
            return "[String:String]"
        case .fragment(_),
             .all(_,_),
             .one(_,_),
             .any(_,_),
             .not(_,_):
            throw ResolvementError.NotSupported(msg: "No $of operators nor objects allowed as primitive types")
        }
    }
    
    /// Resolves primitive types defined in open api document
    /// - Parameter schema: dereferenced schema to check
    /// - Throws: error if type cannot be resolved
    /// - Returns: type as String
    static func resolveTypeFormat(schema: DereferencedJSONSchema) throws -> String {
        return try resolveTypeFormat(schema: schema.jsonSchema)
    }
    
    
    /// Resolves types defined in open api document
    /// - Parameter schema: OpenAPIKit type - either references or schema type
    /// - Throws: error if type cannot be resolved
    /// - Returns: type as String
    static func resolveTypeFormat(schema: Either<JSONReference<JSONSchema>, JSONSchema>?) throws -> String {
        guard let schema = schema else {
            return "Error"
        }
        
        guard let a = schema.a else {
            return try resolveTypeFormat(schema: schema.b!)
        }
        
        if let name = a.name {
            return "_\(name)"
        }
        
        return try ReferenceResolver.resolveType(schema: a)
        
    }
}
