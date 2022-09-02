//
//  Mod.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

struct Mod {
    var arg1: any Expression
    /// Modulus
    var arg2: any Expression
}

extension Mod: Hashable, CustomStringConvertible {
    static func == (lhs: Mod, rhs: Mod) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { "(" + arg1.description + " mod " + arg2.description + ")" }
}

extension Mod: Boundable {
    public typealias N = AnyScalar
    public var min: N { -Swift.max(AnyScalar(arg2.min.abs), AnyScalar(arg2.max.abs)) }
    public var max: N { Swift.max(AnyScalar(arg2.min.abs), AnyScalar(arg2.max.abs)) }
}

extension Mod: Expression {
    var eType: ExpressionType {
        .binaryOperation(
            bType: .mod,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).logx(x: arg2.eval(x: x)) }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Mod(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
