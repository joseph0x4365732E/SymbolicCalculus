//
//  File.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public struct AnyScalar {
    public var scalar: any Scalar
    public var sType: ScalarType { scalar.sType }
}

extension AnyScalar: Hashable, Comparable {
    public static func == (lhs: AnyScalar, rhs: AnyScalar) -> Bool { lhs.scalar.equals(rhs.scalar) }
    
    public func hash(into hasher: inout Hasher) { scalar.hash(into: &hasher) }
    
    public static func < (lhs: AnyScalar, rhs: AnyScalar) -> Bool { lhs.scalar.lessThan(rhs.scalar) }
}

extension AnyScalar: CustomStringConvertible {
    public var description: String { scalar.description }
}

extension AnyScalar: AdditiveArithmetic {
    public static func + (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar { AnyScalar(scalar: lhs.scalar.plus(rhs.scalar)) }
    
    public static func - (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        var minus = rhs.scalar
        minus.negate()
        return AnyScalar(scalar: lhs.scalar.plus(minus))
    }
}

extension AnyScalar: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) { self.scalar = Double(value) }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard source is any Scalar else { return nil }
        self.scalar = (source as! any Scalar)
    }
}

extension AnyScalar: Numeric {
    public static func * (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        guard lhs.sType == rhs.sType else { fatalError("Cannot multiply different types of AnyScalar: \(lhs.sType) and \(rhs.sType).") }
        return AnyScalar(scalar: lhs.scalar.multiplied(by: rhs.scalar))
    }
    
    public static func *= (lhs: inout AnyScalar, rhs: AnyScalar) { lhs = lhs * rhs }
}

extension AnyScalar: SignedNumeric {
    public typealias Magnitude = AnyScalar
    
    public var magnitude: AnyScalar { AnyScalar(scalar: scalar.magnitude as! any Scalar) }

    
}

extension AnyScalar: KnownSign {
    public var isNegative: Bool { scalar.isNegative }
    
    public var abs: AnyScalar { AnyScalar(scalar: scalar.abs) }
}

extension AnyScalar: Scalar {
    public static var staticType: ScalarType { .any }
    
    public static var min: AnyScalar {
        AnyScalar(scalar: -Double(Int.max))
    }
    
    public static var max: AnyScalar {
        AnyScalar(scalar: Double(Int.max))
    }
    
    public static var infinity: AnyScalar { AnyScalar(scalar: Double.infinity) }
    
    public var double: Double { scalar.double }
    
    public func equals(_ other: any Scalar) -> Bool { scalar.equals(other) }
    
    public func lessThan(_ other: any Scalar) -> Bool { scalar.lessThan(other) }
    
    public func plus(_ other: any Scalar) -> AnyScalar { AnyScalar(scalar: scalar.plus(other)) }
    
    public func multiplied(by other: any Scalar) -> any Scalar { scalar.multiplied(by: other) }
}
