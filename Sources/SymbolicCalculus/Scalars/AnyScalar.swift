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
    public static let staticType: ScalarType = .any

    public init(_ value: any Scalar) {
        self.scalar = value
    }
    
    static func withTypedCombine<ReturnType>(
        lhs: AnyScalar,
        rhs: AnyScalar,
        ifDouble: (Double, Double) -> (ReturnType),
        ifFraction: (Fraction, Fraction) -> (ReturnType)
    ) -> ReturnType {
        let type = ScalarType(combining: lhs.sType, rhs.sType)
        switch type {
        case .fraction:
            return ifFraction(Fraction(lhs), Fraction(rhs))
        case .double:
            return ifDouble(Double(lhs), Double(rhs))
        default: fatalError("Invalid scalar type for withTypedCombine: \(type).")
        }
    }
}

extension AnyScalar: Hashable, Comparable {
    public static func == (lhs: AnyScalar, rhs: AnyScalar) -> Bool {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { $0 == $1 },
            ifFraction: { $0 == $1 }
        )
    }
    
    public func hash(into hasher: inout Hasher) { scalar.hash(into: &hasher) }
    
    public static func < (lhs: AnyScalar, rhs: AnyScalar) -> Bool {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { $0 < $1 },
            ifFraction: { $0 < $1 }
        )
    }
}

extension AnyScalar: CustomStringConvertible {
    public var description: String { scalar.description }
}

extension AnyScalar: AdditiveArithmetic {
    public static func + (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { AnyScalar($0 + $1) },
            ifFraction: { AnyScalar($0 + $1) }
        )
    }
    
    public static func - (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { AnyScalar($0 - $1) },
            ifFraction: { AnyScalar($0 - $1) }
        )
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
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { AnyScalar($0 * $1) },
            ifFraction: { AnyScalar($0 * $1) }
        )
    }
    
    public static func *= (lhs: inout AnyScalar, rhs: AnyScalar) { lhs = lhs * rhs }
}

extension AnyScalar: SignedNumeric {
    public typealias Magnitude = AnyScalar
    
    public var magnitude: AnyScalar { AnyScalar(scalar.magnitude as! any Scalar) }
}

extension AnyScalar: Scalar {
    
    /// **Initializers**
    public init(_ value: Double) { scalar = value }
    
    /// **Type Enumeration**
    
    /// **Static Vars**
    /// Range
    public static var min: AnyScalar { AnyScalar(-Double(Int.max)) }
    public static var max: AnyScalar { AnyScalar(Double(Int.max)) }
    /// Special Values
    public static var infinity: AnyScalar { AnyScalar(Double.infinity) }
    public static var nan: AnyScalar { AnyScalar(Double.nan) }
    
    /// **Computed Vars**
    /// Computed Bool States
    public var isWhole: Bool { scalar.isWhole }
    public var isFinite: Bool { scalar.isFinite }
    public var isNaN: Bool { scalar.isNaN }
    /// Computed Values
    public var double: Double { scalar.double }
    public var factorial: AnyScalar { AnyScalar(scalar.factorial) }
    public var sqrt: AnyScalar { AnyScalar(scalar.sqrt) }
    public var ln: AnyScalar { AnyScalar(scalar.ln) }
    public var log2: AnyScalar { AnyScalar(scalar.log2) }
    public var log10: AnyScalar { AnyScalar(scalar.log10) }
    
    ///  **Functions**
    /// Exponents
    /// Division, Modulus
    public static func / (lhs: AnyScalar, rhs: AnyScalar) -> AnyScalar {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDouble: { AnyScalar($0 / $1) },
            ifFraction: { AnyScalar($0 / $1) }
        )
    }
    /// Derivative
}
