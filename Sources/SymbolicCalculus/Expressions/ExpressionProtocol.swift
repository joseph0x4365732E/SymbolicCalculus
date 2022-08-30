//
//  Expression.swift
//  
//
//  Created by Joseph Cestone on 8/17/22.
//

import Foundation

public protocol Boundable {
    associatedtype N: Scalar
    var min: N { get }
    var max: N { get }
}

public protocol Simplifiable {
    #warning("finish this 💩")
    func simplified() -> any Expression
}

public protocol Expression: Hashable, CustomStringConvertible, Boundable, Simplifiable {
    var eType: ExpressionType { get }
    func eval(x: any Scalar) -> any Scalar
    func equals(_ other: any Expression) -> Bool
    func multiplied(by other: any Expression) -> any Expression
}

public protocol Differentiable: Expression {
    func nthDerivative(n: N) -> any Expression
}

public protocol Integrable: Expression {
    func nthIntegral(n: N) -> any Expression
}
