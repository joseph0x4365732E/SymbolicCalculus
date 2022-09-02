//
//  Difference.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

struct Difference {
    var arg1: any Expression
    var arg2: any Expression
}

extension Difference: Hashable, CustomStringConvertible {
    static func == (lhs: Difference, rhs: Difference) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { arg1.description + " - " + arg2.description }
}

extension Difference: Boundable {
    public typealias N = AnyScalar
    public var min: N {
        AnyScalar(arg1.min) -
        AnyScalar(arg2.max)
    }
    public var max: N {
        AnyScalar(arg1.max) +
        AnyScalar(arg2.max)
    }
}

extension Difference: Expression {
    var eType: ExpressionType { .binaryOperation(bType: .difference, sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)) }
    func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).plus(arg2.eval(x: x).negated()) }
    
    func simplified() -> any Expression {
        arg1.plus(arg2.negated())
    }
    
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Difference(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
}
