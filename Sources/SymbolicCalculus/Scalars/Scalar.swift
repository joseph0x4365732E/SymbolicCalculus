//
//  Scalar.swift
//  
//
//  Created by Joseph Cestone on 8/18/22.
//

import Foundation

extension SignedNumeric where Self: Comparable {
    var isNegative: Bool { self < Self.zero }
    var abs: Self { magnitude as! Self }
}

public protocol Scalar:  Hashable, Comparable, CustomStringConvertible, SignedNumeric {
    /// **Initializers**
    init(_ value: Double)
    init(_ value: any Scalar)
    
    /// **Type Enumeration**
    static var staticType: ScalarType { get }
    var sType: ScalarType { get }
    
    /// **Static Vars**
    /// Range
    static var min: Self { get }
    static var max: Self { get }
    /// Special Values
    static var infinity: Self { get }
    static var nan: Self { get }
    
    /// **Computed Vars**
    /// Computed Bool States
    var isWhole: Bool { get }
    var isFinite: Bool { get }
    var isNaN: Bool { get }
    /// Computed Values
    var double: Double { get }
    var factorial: Self { get }
    var sqrt: Self { get }
    var ln: Self { get }
    var log2: Self { get }
    var log10: Self { get }
    
      
    ///  **Functions**
    /// Exponents
    func power(_ exponent: Self) -> Self
    func logx(x: Self) -> Self
    /// Division, Modulus
    static func / (lhs: Self, rhs: Self) -> Self
    func mod(_ modulus: Self) -> Self
    /// Derivative
    func nthDerivative(_ n: Self) -> Self
}

extension Scalar {
    /// **Static Vars**
    /// Range
    /// Special Values

    /// **Computed Vars**
    /// Computed Bool States
    /// Computed Values
    public var factorial: Self {
        guard isWhole else { return .nan }
        guard self <= 171 else { return .infinity }
        return (2...Int(double)).map { Self(exactly: $0)! }.product
    }
    public var sqrt: Self { Self(double.squareRoot()) }
    public var ln: Self { Self(Darwin.log(double)) }
    public var log2: Self { Self(Darwin.log2(double)) }
    public var log10: Self { Self(Darwin.log2(double) / Darwin.log2(10.0)) }
      
    ///  **Functions**
    /// Exponents
    public func power(_ exponent: Self) -> Self { Self(pow(double, exponent.double)) }
    public func logx(x: Self) -> Self { Self(Darwin.log2(double) / Darwin.log2(x.double)) }
    /// Division, Modulus
    public func mod(_ modulus: Self) -> Self {
        // Mod of negative number starts at number and keeps adding modulus until its positive
        return Self(double.remainder(dividingBy: modulus.double))
    }
    /// Derivative
    public func nthDerivative(_ n: Self) -> Self {
        guard n.isWhole && n >= 0 else { return .nan }
        if n == 0 { return self }
        if n <= 1 { return .zero }
        fatalError("Invalid n \(n) for nth derivative of \(self).")
    }
}
// MARK: Double
extension Double: Scalar {
    public var sType: ScalarType { .double }
    public static let staticType: ScalarType = .double
    public static var min: Double { -.greatestFiniteMagnitude }
    public static var max: Double { .greatestFiniteMagnitude }
    public var abs: Double { magnitude }
    public var double: Double { self }
    public init(_ value: any Scalar) {
        switch value {
        case is Fraction: self = (value as! Fraction).double
        case is Double: self = value as! Double
        case is AnyScalar: self = Self((value as! AnyScalar).scalar)
        default:
            fatalError("Cannot init Double: Unsupported scalar type \(type(of: value))")
        }
    }
    public var isWhole: Bool { (rounded() - self).abs < (self.ulp * 10) }
    public var factorial: Double {
        guard isWhole else { return .nan }
        guard self <= 171.1 else { return .infinity }
        return (2...Int(self)).map { Double($0) }.product
    }
}

//MARK: Fraction
extension Fraction: Scalar {
    public init(_ value: any Scalar) {
        switch value {
        case is Fraction: self = value as! Fraction
        case is Double: self = Fraction(value as! Double)
        case is AnyScalar: self = Self((value as! AnyScalar).scalar)
        default:
            fatalError("Cannot init Double: Unsupported scalar type \(type(of: value))")
        }
    }
    
    public var sType: ScalarType { .fraction }
    public static let staticType: ScalarType = .fraction
    public static var min: Fraction { Fraction(integerLiteral: -Int.max) }
    public static var max: Fraction { Fraction(integerLiteral: Int.max) }
    
    public var isFinite: Bool { !isInfinite }
    public var isNaN: Bool { numerator == 0 && isFinite }
    public var double: Double {
        Double(whole) + doubleDecimal
    }
//    public func power(_ exponent: Int) -> Fraction {
//        Fraction(numerator: numerator.power(exponent), denominator: denominator.power(exponent))
//    }
}
