//
//  Difference.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Difference: BinaryOperation {
    public var arg1: any Expression
    public var arg2: any Expression
    
    public init(arg1: any Expression, arg2: any Expression) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

extension Difference: Hashable, CustomStringConvertible {
    public static func == (lhs: Difference, rhs: Difference) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String { arg1.description + " - " + arg2.description }
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
    public var eType: ExpressionType { .binaryOperation(bType: .difference, sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)) }
    public func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).plus(arg2.eval(x: x).negated()) }
    
    public func simplified() -> any Expression {
        arg1.plus(arg2.negated())
    }
    
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Difference(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
}
