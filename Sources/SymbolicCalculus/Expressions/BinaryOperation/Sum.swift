//
//  Sum.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Sum: BinaryOperation {
    public var arg1: any Expression
    public var arg2: any Expression
    
    public init(arg1: any Expression, arg2: any Expression) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

extension Sum: Hashable, CustomStringConvertible {
    public static func == (lhs: Sum, rhs: Sum) -> Bool {
        #warning("Does not account for simplifying")
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String { arg1.description + " + " + arg2.description }
}

extension Sum: Boundable {
    public typealias N = AnyScalar
    public var min: N {
        AnyScalar(arg1.min) +
        AnyScalar(arg2.min)
    }
    public var max: N {
        AnyScalar(arg1.max) +
        AnyScalar(arg2.max)
    }
}

extension Sum: Expression {
    public var eType: ExpressionType { .binaryOperation(bType: .sum, sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)) }
    public func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).plus(arg2.eval(x: x)) }
    
    public func simplified() -> any Expression {
        arg1.plus(arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Sum(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    public var abs: any Expression {
        let arg1Sim = arg1.simplified()
        let arg2Sim = arg2.simplified()
        
        guard let arg1N = arg1Sim.isNegative,
              let arg2N = arg2Sim.isNegative,
              arg1N == arg2N else {
            return Abs(arg1: Sum(arg1: arg1Sim, arg2: arg2Sim))
        }
        if arg1N { // both negative
            return Sum(arg1: arg1Sim.abs, arg2: arg2Sim.abs)
        } else { // both positive
            return Sum(arg1: arg1Sim, arg2: arg2Sim)
        }
    }
    
}
