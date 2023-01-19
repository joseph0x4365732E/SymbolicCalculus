//
//  Variable.swift
//  
//
//  Created by Joseph Cestone on 9/12/22.
//

import Foundation

public struct Variable<C: Scalar> {
    public var name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

// MARK: CustomStringConvertible
extension Variable: Hashable, CustomStringConvertible {
    public var description: String { name }
}

extension Variable: Boundable {
    public typealias N = C
    
    public var min: C { .max }
    public var max: C { .max }
}

extension Variable: Expression {
    
    public var eType: ExpressionType { .constant(sType: C.staticType) }
    public var resolved: Bool { true }
    
    // MARK: eval(x)
    public func eval(x: AnyScalar) -> AnyScalar {
        fatalError("This needs to be changed - should accept dictionary of values for variable names.")
    }
}

// MARK: d/dx
//extension Variable: Differentiable {
//    public func nthDerivative(n: C) -> any Expression {
//        Variable.zero
//    }
//}
//
//// MARK: ∫ self dx
//extension Variable: Integrable {
//    public func nthIntegral(n: C) -> any Expression {
//        #warning("ignores the +C of the integral")
//        return Polynomial(standardCoefficients: constant, C.zero)
//    }
//}
