//
//  NthIntegral.swift
//  
//
//  Created by Joseph Cestone on 9/1/22.
//

import Foundation

struct NthIntegral {
    var arg1: any Expression
    /// N
    var arg2: any Expression
}

extension NthIntegral: Hashable, CustomStringConvertible {
    static func == (lhs: NthIntegral, rhs: NthIntegral) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { "NthIntegral(n: " + arg1.description + ", " + arg2.description + ")" }
}

extension NthIntegral: Boundable {
    public typealias N = AnyScalar
    public var min: N { N.min }
    public var max: N { N.max }
}

extension NthIntegral: Expression {
    var eType: ExpressionType {
        .binaryOperation(
            bType: .nthIntegral,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    func eval(x: any Scalar) -> any Scalar { fatalError() }
    
    func simplified() -> any Expression {
        arg1.nthIntegral(n: arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        NthIntegral(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
