//
//  AnyScalar.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public struct AnyScalar {
    public var scalar: any Scalar
    public var sType: ScalarType { scalar.sType }
    
    init(_ scalar: any Scalar) {
        self.scalar = scalar
    }
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
    public static func + (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar { AnyScalar(lhs.scalar.plus(rhs.scalar)) }
    
    public static func - (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        var minus = rhs.scalar
        minus.negate()
        return AnyScalar(lhs.scalar.plus(minus))
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
        return AnyScalar(lhs.scalar.multiplied(by: rhs.scalar))
    }
    
    public static func *= (lhs: inout AnyScalar, rhs: AnyScalar) { lhs = lhs * rhs }
}

extension AnyScalar: SignedNumeric {
    public typealias Magnitude = AnyScalar
    
    public var magnitude: AnyScalar { AnyScalar(scalar.magnitude as! any Scalar) }
}

extension AnyScalar: Scalar {
    public init(_ value: Double) { scalar = value }
    public static var staticType: ScalarType { .any }
    public static var min: AnyScalar { AnyScalar(-Double(Int.max)) }
    public static var max: AnyScalar { AnyScalar(Double(Int.max)) }
    
    public var double: Double { scalar.double }
    public var isWhole: Bool { scalar.isWhole }
    public var factorial: AnyScalar { AnyScalar(scalar.factorial) }
    
    public var isFinite: Bool { scalar.isFinite }
    public var isNaN: Bool { scalar.isNaN }
    
    public static var infinity: AnyScalar { AnyScalar(Double.infinity) }
    public static var nan: AnyScalar { AnyScalar(Double.nan) }
    
    
    
    
    public func equals(_ other: any Scalar) -> Bool { scalar.equals(other) }
    public func lessThan(_ other: any Scalar) -> Bool { scalar.lessThan(other) }
    public func plus(_ other: any Scalar) -> AnyScalar { AnyScalar(scalar.plus(other)) }
    public func multiplied(by other: any Scalar) -> AnyScalar { AnyScalar(scalar.multiplied(by: other)) }
    public func divided(by other: any Scalar) -> AnyScalar { AnyScalar(scalar.divided(by: other)) }
    public func power(_ exponent: Int) -> AnyScalar { AnyScalar(scalar.power(exponent)) }
    public func powerUsingDouble(_ exponent: AnyScalar) -> AnyScalar { AnyScalar(pow(double, exponent.double)) }
    public func logx(x: any Scalar) -> AnyScalar { AnyScalar(scalar.logx(x: x)) }
}
extension AnyScalar: Divisible {
    public func isMultiple(of: AnyScalar) -> Bool { true }
    
    public static func / (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        AnyScalar(lhs.scalar.divided(by: rhs.scalar))
    }
    
    public static func % (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar { .zero }
}
