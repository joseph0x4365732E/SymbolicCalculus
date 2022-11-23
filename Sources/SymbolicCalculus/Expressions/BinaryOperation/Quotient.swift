//
//  Quotient.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Quotient: BinaryOperation {
    /// Numerator
    public var arg1: any Expression
    /// Denominator
    public var arg2: any Expression
    
    public init(arg1: any Expression, arg2: any Expression) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
    
    var reciprocal: any Expression { arg2.divided(by: arg1) }
}

extension Quotient: Hashable, CustomStringConvertible {
    public static func == (lhs: Quotient, rhs: Quotient) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String { arg1.description + " / " + arg2.description }
}

extension Quotient: Boundable {
    public typealias N = AnyScalar
    public var min: N {
        let a1Ma = AnyScalar(arg1.max)
        let a1Mi = AnyScalar(arg1.min)
        let a2Ma = AnyScalar(arg2.max)
        let a2Mi = AnyScalar(arg2.min)
        
        let minOverMax = a1Mi / a2Ma
        let minOverMin = a1Mi / a2Mi
        let maxOverMax = a2Ma / a2Ma
        let maxOverMin = a2Ma / a2Mi
        return Swift.min(minOverMax, minOverMin, maxOverMax, maxOverMin)
    }
    public var max: N {
        let a1Ma = AnyScalar(arg1.max)
        let a1Mi = AnyScalar(arg1.min)
        let a2Ma = AnyScalar(arg2.max)
        let a2Mi = AnyScalar(arg2.min)
        
        let minOverMax = a1Mi / a2Ma
        let minOverMin = a1Mi / a2Mi
        let maxOverMax = a2Ma / a2Ma
        let maxOverMin = a2Ma / a2Mi
        return Swift.max(minOverMax, minOverMin, maxOverMax, maxOverMin)
    }
}
extension Quotient: Expression {
    public var eType: ExpressionType { .binaryOperation(bType: .quotient, sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)) }
    public func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).multiplied(by: arg2.eval(x: x)) }
    
    public func simplified() -> any Expression {
        arg1.divided(by: arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
    public func multiplied(by other: any Expression) -> any Expression {
        #warning("This changes the scalar type - fix eventually")
        if other.equivalent(to: reciprocal) { return Constant(AnyScalar(1.0)) }
        if other.equivalent(to: arg2) { return arg1.simplified() }
        return arg1.multiplied(by: other).divided(by: arg2)
    }
    
    public func divided(by other: any Expression) -> any Expression {
        if other.equivalent(to: self) { return Constant(AnyScalar(1.0)) }
        if other.equivalent(to: arg1) { return Constant(AnyScalar(1.0)).divided(by: arg2) }
        return arg1.divided(by: arg2.multiplied(by: other))
    }
    
    public var abs: any Expression {
        let arg1Sim = arg1.simplified()
        let arg2Sim = arg2.simplified()
        
        guard let arg1N = arg1Sim.isNegative,
              let arg2N = arg2Sim.isNegative else {
            return Abs(arg1: Quotient(arg1: arg1Sim, arg2: arg2Sim))
        }
        if arg1N == arg2N {
            if arg1N { // both negative
                return Quotient(arg1: arg1Sim.abs, arg2: arg2Sim.abs)
            } else { // both positive
                return Quotient(arg1: arg1Sim, arg2: arg2Sim)
            }
        }
        
        if arg1N { // 1 is negative
            return Quotient(arg1: arg1Sim.abs, arg2: arg2Sim)
        } else { // 2 is negative
            return Quotient(arg1: arg1Sim, arg2: arg2Sim.abs)
        }
    }
}
