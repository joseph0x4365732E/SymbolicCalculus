//
//  NthDerivative.swift
//  
//
//  Created by Joseph Cestone on 8/31/22.
//

import Foundation

struct NthDerivative {
    var arg1: any Expression
    /// N
    var arg2: any Expression
}

extension NthDerivative: Hashable, CustomStringConvertible {
    static func == (lhs: NthDerivative, rhs: NthDerivative) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { "NthDerivative(n: " + arg1.description + ", " + arg2.description + ")" }
}

extension NthDerivative: Boundable {
    public typealias N = AnyScalar
    public var min: N { N.min }
    public var max: N { N.max }
}

extension NthDerivative: Expression {
    var eType: ExpressionType {
        .binaryOperation(
            bType: .nthDerivative,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    func eval(x: any Scalar) -> any Scalar { fatalError() }
    
    func simplified() -> any Expression {
        arg1.nthDerivative(n: arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        NthDerivative(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
