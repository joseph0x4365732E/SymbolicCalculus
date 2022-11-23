//
//  NthDerivative.swift
//  
//
//  Created by Joseph Cestone on 8/31/22.
//

import Foundation

public struct NthDerivative: BinaryOperation {
    public var arg1: any Expression
    /// N
    public var arg2: any Expression
    
    public init(arg1: any Expression, arg2: any Expression) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

extension NthDerivative: Hashable, CustomStringConvertible {
    public static func == (lhs: NthDerivative, rhs: NthDerivative) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String { "NthDerivative(n: " + arg1.description + ", " + arg2.description + ")" }
}

extension NthDerivative: Boundable {
    public typealias N = AnyScalar
    public var min: N { N.min }
    public var max: N { N.max }
}

extension NthDerivative: Expression {
    public var eType: ExpressionType {
        .binaryOperation(
            bType: .nthDerivative,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    public func eval(x: any Scalar) -> any Scalar { fatalError() }
    
    public func simplified() -> any Expression {
        arg1.nthDerivative(n: arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        NthDerivative(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
