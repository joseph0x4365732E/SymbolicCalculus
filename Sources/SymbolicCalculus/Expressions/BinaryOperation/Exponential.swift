//
//  Exponential.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

struct Exponential {
    var arg1: any Expression
    var arg2: any Expression
}

extension Exponential: Hashable, CustomStringConvertible {
    static func == (lhs: Exponential, rhs: Exponential) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { arg1.description + " ^ " + arg2.description }
}

extension Exponential: Boundable {
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
        
        let minPowerMax = a1Mi.powerUsingDouble(a2Ma)
        let minPowerMin = a1Mi.powerUsingDouble(a2Mi)
        let maxPowerMax = a2Ma.powerUsingDouble(a2Ma)
        let maxPowerMin = a2Ma.powerUsingDouble(a2Mi)
        return Swift.max(minPowerMax, minPowerMin, maxPowerMax, maxPowerMin)
    }
}

extension Exponential: Expression {
    var eType: ExpressionType {
        .binaryOperation(
            bType: .exponential,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).multiplied(by: arg2.eval(x: x)) }
    
    func simplified() -> any Expression {
        arg1.power(arg2)
    }
    var abs: any Expression {
        let arg1Sim = arg1.simplified()
        let arg2Sim = arg2.simplified()
        
        guard let arg1N = arg1Sim.isNegative,
              let arg2N = arg2Sim.isNegative else {
            return Abs(arg1: Exponential(arg1: arg1Sim, arg2: arg2Sim))
        }
        if arg1N == arg2N {
            return Exponential(arg1: arg1Sim, arg2: arg2Sim)
        }
        
        if arg1N { // 1 is negative
            return Exponential(arg1: arg1Sim.abs, arg2: arg2Sim)
        } else { // 2 is negative
            return Exponential(arg1: arg1Sim, arg2: arg2Sim.abs)
        }
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Exponential(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
