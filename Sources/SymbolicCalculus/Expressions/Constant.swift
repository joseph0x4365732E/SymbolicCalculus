//
//  Constant.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Constant<C: Scalar> {
    public var scalar: C
    
    init(_ scalar: C) {
        self.scalar = scalar
    }
}

// MARK: CustomStringConvertible
extension Constant: Hashable, CustomStringConvertible {
    public var description: String {
        scalar.description
    }
}

extension Constant: Boundable {
    public typealias N = C
    
    public var min: C { scalar }
    public var max: C { scalar }
}

extension Constant: Expression {
    public func eval(x: any Scalar) -> any Scalar {
        guard x is C else { fatalError("Cannot evaluate \(type(of: self)) with x of type \(x.sType).") }
        return eval(x: x as! C)
    }
    
    public var eType: ExpressionType { .polynomial(sType: C.staticType) }
    
    // MARK: eval(x)
    public func eval(x: C) -> C {
        return scalar
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Self else { return false }
        return (other as! Self) == self
    }
    public func multiplied(by other: any Expression) -> any Expression {
        guard other is Self else { fatalError("Can't multiply Polynomial by other expression type \(other.eType).") }
        return (other as! Self) * self
    }
//    public func power(_ exponent: Int) -> Constant<C> {
//        Constant(scalar.power(exponent))
//    }
    
    public var constant: AnyScalar? { AnyScalar(scalar) }
    public func simplified() -> any Expression { self }
    public var abs: any Expression { Constant(scalar.abs) }
}

// MARK: Const.zero
extension Constant: Zeroable {
    public static var zero: Constant<C> {
        Constant(C.zero)
    }
}

// MARK: Const(Int)
extension Constant: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.scalar = C(exactly: value)!
    }
}

// MARK: Const + Const
extension Constant: Addable {
    public static func + (lhs: Constant<C>, rhs: Constant<C>) -> Constant<C> {
        Constant(lhs.scalar + rhs.scalar)
    }
}

// MARK: Const - Const
extension Constant: Negatable  {
    public mutating func negate() {
        scalar.negate()
    }
    
    public func negated() -> Constant<C> {
        Constant(-scalar)
    }

    public static func - (lhs: Constant, rhs: Constant) -> Constant {
        Constant(lhs.scalar - rhs.scalar)
    }
}

// MARK: Const * Const
extension Constant: Multipliable {
    public static func * (lhs: Constant<C>, rhs: Constant<C>) -> Constant<C> {
        Constant(lhs.scalar * rhs.scalar)
    }
}

// MARK: reciprocal
extension Constant: Reciprocable {
    public var reciprocal: Constant<C> {
        return Constant(C(exactly: 1)!.divided(by: scalar))
    }
}

// MARK: d/dx
//extension Constant: Differentiable {
//    public func nthDerivative(n: C) -> any Expression {
//        Constant.zero
//    }
//}
//
//// MARK: ∫ self dx
//extension Constant: Integrable {
//    public func nthIntegral(n: C) -> any Expression {
//        #warning("ignores the +C of the integral")
//        return Polynomial(standardCoefficients: constant, C.zero)
//    }
//}
