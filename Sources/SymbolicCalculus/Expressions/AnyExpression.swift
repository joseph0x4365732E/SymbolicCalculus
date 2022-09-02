//
//  File.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public struct AnyExpression  {
    public var eType: ExpressionType { exp1.eType }
    public var exp1: any Expression
}

extension AnyExpression: Boundable {
    public typealias N = AnyScalar
    public var min: N { AnyScalar(exp1.min) }
    public var max: N { AnyScalar(exp1.max) }
}

extension AnyExpression: Hashable {
    public static func == (lhs: AnyExpression, rhs: AnyExpression) -> Bool {
        lhs.exp1.equals(rhs.exp1)
    }
    
    public func hash(into hasher: inout Hasher) {
        exp1.hash(into: &hasher)
    }
}

extension AnyExpression: CustomStringConvertible {
    public var description: String { exp1.description }
}

extension AnyExpression: Expression {
    public func eval(x: any Scalar) -> any Scalar {
        exp1.eval(x: x)
    }
    
    public func equals(_ other: any Expression) -> Bool {
        exp1.equals(other)
    }
    
    public func multiplied(by other: any Expression) -> any Expression {
        exp1.multiplied(by: other)
    }
    
    public func simplified() -> any Expression {
        exp1.simplified()
    }

}
