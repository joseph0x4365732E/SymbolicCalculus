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
    public func eval(x: any Scalar) -> any Scalar {
        guard x is C else { fatalError("Cannot evaluate \(type(of: self)) with x of type \(x.sType).") }
        return eval(x: x as! C)
    }
    
    public var eType: ExpressionType { .constant(sType: C.staticType) }
    public var resolved: Bool { true }
    
    // MARK: eval(x)
    public func eval(x: C) -> C {
        fatalError("This needs to be changed - should accept dictionary of values for variable names.")
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Self else { return false }
        return (other as! Self) == self
    }
//    public func power(_ exponent: Int) -> Variable<C> {
//        Variable(scalar.power(exponent))
//    }
    
    public func simplified() -> any Expression { self }
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
