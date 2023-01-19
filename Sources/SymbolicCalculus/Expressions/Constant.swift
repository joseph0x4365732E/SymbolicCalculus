//
//  Constant.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Constant<C: Scalar> {
    public var scalar: C
    
    public init(_ scalar: C) {
        self.scalar = scalar
    }
}


extension Constant: Boundable {
    public typealias N = C
    
    public var min: C { scalar }
    public var max: C { scalar }
}

extension Constant: Hashable, Comparable {
    public static func == (lhs: Constant<C>, rhs: Constant<C>) -> Bool {
        lhs.scalar == rhs.scalar
    }
    
    public static func < (lhs: Constant<C>, rhs: Constant<C>) -> Bool {
        lhs.scalar < rhs.scalar
    }
}

extension Constant: CustomStringConvertible {
    public var description: String {
        scalar.description
    }
}

extension Constant: AdditiveArithmetic {
    public static func + (lhs: Constant<C>, rhs: Constant<C>) -> Constant<C> {
        Constant(lhs.scalar + rhs.scalar)
    }
    
    public static func - (lhs: Constant<C>, rhs: Constant<C>) -> Constant<C> {
        Constant(lhs.scalar - rhs.scalar)
    }
}

extension Constant: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.scalar = C(exactly: value)!
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.scalar = C(exactly: source)!
    }
}

extension Constant: Numeric {
    
    public var magnitude: C { scalar.abs }
    
    public typealias Magnitude = C
    
    public static func * (lhs: Constant<C>, rhs: Constant<C>) -> Constant<C> {
        Constant(lhs.scalar * rhs.scalar)
    }
    
    public static func *= (lhs: inout Constant<C>, rhs: Constant<C>) { lhs = lhs * rhs }
}


extension Constant: Expression {
    public var eType: ExpressionType { .constant(sType: C.staticType) }
    public var resolved: Bool { true }
    
    // MARK: eval(x)
    public func eval(x: AnyScalar) -> AnyScalar {
        return AnyScalar(scalar)
    }
    public func multiplied(by other: any Expression) -> any Expression {
        guard other is Self else { fatalError("Can't multiply Polynomial by other expression type \(other.eType).") }
        return (other as! Self) * self
    }
//    public func power(_ exponent: Int) -> Constant<C> {
//        Constant(scalar.power(exponent))
//    }
    
    public var constant: AnyScalar? { AnyScalar(scalar) }
    public var abs: any Expression { Constant(scalar.abs) }
}

// MARK: Const.zero
extension Constant: Zeroable {
    public static var zero: Constant<C> {
        Constant(C.zero)
    }
}

