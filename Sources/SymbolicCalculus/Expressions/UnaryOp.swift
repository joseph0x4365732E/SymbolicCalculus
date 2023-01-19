//
//  UnaryOp.swift
//  
//
//  Created by Joseph Cestone on 12/21/22.
//

import Foundation

public struct UnaryOp<S: Scalar> {
    public var type: ExpressionType.UnaryOpType
    public var sType: ScalarType
    public var arg1: AnyExpression<S>
    private var scalarOp: (S) -> (S) {
        switch type {
        case .abs:          return { $0.abs }
        case .negative:     return { -$0 }
        case .sqrt:         return { $0.sqrt }
        case .ln:           return { $0.ln }
        case .log2:         return { $0.log2 }
        case .log10:        return { $0.log10 }
        case .factorial:    return { $0.factorial }
        }
    }
    
    public init(_ type: ExpressionType.UnaryOpType, sType: ScalarType, arg1: AnyExpression<S>) {
        self.type = type
        self.sType = sType
        self.arg1 = arg1
    }
}

extension UnaryOp: Boundable {
    public typealias N = S
    private var possibleExtremes: [S] { [scalarOp(arg1.min), scalarOp(arg1.max)] }
    #warning("this does not work for expressions like sine and cosine")
    public var min: S { return possibleExtremes.min()! }
    public var max: S { return possibleExtremes.max()! }
}

extension UnaryOp: Hashable, CustomStringConvertible {
    
    public static func == (lhs: UnaryOp<S>, rhs: UnaryOp<S>) -> Bool {
        lhs.type == rhs.type &&
        lhs.arg1 == rhs.arg1
    }
    
    public func hash(into hasher: inout Hasher) {
        type.hash(into: &hasher)
        arg1.hash(into: &hasher)
    }
    
    public var description: String { type.stringConversion(arg1: arg1) }
}

extension UnaryOp: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: type, sType: sType, arg1Type: arg1.eType) }
    public var resolved: Bool { arg1.resolved }
    
    public func eval(x: AnyScalar) -> AnyScalar {
        AnyScalar(scalarOp(S(arg1.eval(x: x))))
    }
}

extension UnaryOp {
    public static func abs<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.abs, sType: S.staticType, arg1: arg1)
    }
    
    public static func factorial<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.factorial, sType: S.staticType, arg1: arg1)
    }
    
    public static func ln<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.ln, sType: S.staticType, arg1: arg1)
    }
    
    public static func log2<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.log2, sType: S.staticType, arg1: arg1)
    }
    
    public static func log10<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.log10, sType: S.staticType, arg1: arg1)
    }
    
    public static func negative<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.negative, sType: S.staticType, arg1: arg1)
    }
    
    public static func sqrt<S: Scalar>(arg1: AnyExpression<S>) -> UnaryOp<S> {
        UnaryOp<S>(.sqrt, sType: S.staticType, arg1: arg1)
    }
}


