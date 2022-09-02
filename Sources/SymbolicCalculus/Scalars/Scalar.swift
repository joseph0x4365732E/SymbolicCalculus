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

public protocol Scalar: CustomStringConvertible, SignedNumeric, Hashable, Comparable {
    init(_ value: Double)
    
    static var staticType: ScalarType { get }
    var sType: ScalarType { get }
    static var min: Self { get }
    static var max: Self { get }
    static var infinity: Self { get }
    static var nan: Self { get }
    var isFinite: Bool { get }
    var isNaN: Bool { get }
    var double: Double { get }
    var isWhole: Bool { get }
    
    var factorial: Self { get }
    
    func equals(_ other: any Scalar) -> Bool
    func lessThan(_ other: any Scalar) -> Bool
    func plus(_ other: any Scalar) -> Self
    mutating func negate()
    func negated() -> Self
    func multiplied(by other: any Scalar) -> Self
    func divided(by other: any Scalar) -> Self
    func power(_ exponent: Int) -> Self
    func logx(x: any Scalar) -> Self
}

extension Scalar {
    public var sqrt: Self { Self(double.squareRoot()) }
    public var ln: Self { Self(Darwin.log(double)) }
    public var log2: Self { Self(Darwin.log2(double)) }
    public var log10: Self { Self(Darwin.log2(double) / Darwin.log2(10.0)) }
    public func negated() -> Self {
        var mutable = self
        mutable.negate()
        return mutable
    }
    public func logx(x: any Scalar) -> Self { Self(Darwin.log2(double) / Darwin.log2(x.double)) }
}

extension Double: Scalar {
    public static var staticType: ScalarType { .double }
    public var sType: ScalarType { .double }
    public static var min: Double { -.greatestFiniteMagnitude }
    public static var max: Double { .greatestFiniteMagnitude }
    public var abs: Double { magnitude }
    public var double: Double { self }
    public var isWhole: Bool { (rounded() - self).abs < (self.ulp * 10) }
    public var factorial: Double {
        guard isWhole else { return .nan }
        guard self <= 171.1 else { return .infinity }
        return (2...Int(self)).map { Double($0) }.product
    }
    
    
    public func equals(_ other: any Scalar) -> Bool {
        guard other is Double else { return false }
        return self == other as! Double
    }
    public func lessThan(_ other: any Scalar) -> Bool { self < other.double }
    public func plus(_ other: any Scalar) -> Double {
        return self + other.double
    }
    public func multiplied(by other: any Scalar) -> Double {
        return self * other.double
    }
    
    public func divided(by other: any Scalar) -> Double {
        return self / other.double
    }
    public func power(_ exponent: Int) -> Double {
        pow(self, Double(exponent))
    }
}


extension Float: Scalar {
    public static var staticType: ScalarType { .float }
    public var sType: ScalarType { .float }
    public static var min: Float { -.greatestFiniteMagnitude }
    public static var max: Float { .greatestFiniteMagnitude }
    public var abs: Float { magnitude }
    public var double: Double { Double(self) }
    public var isWhole: Bool { (rounded() - self).abs < (self.ulp * 10) }
    public var factorial: Float {
        guard isWhole else { return .nan }
        guard self <= 34.1 else { return .infinity }
        return (2...Int(self)).map { Float($0) }.product
    }
    
    public func equals(_ other: any Scalar) -> Bool {
        guard other is Float else { return false }
        return self == other as! Float
    }
    public func lessThan(_ other: any Scalar) -> Bool {
        if other is Float {
            return self < other as! Float
        } else {
            return double < other.double
        }
    }
    public func plus(_ other: any Scalar) -> Float {
        if other is Float {
            return self + (other as! Float)
        } else {
            return Float(double + other.double)
        }
    }
    public func multiplied(by other: any Scalar) -> Float {
        if other is Float {
            return self * (other as! Float)
        } else {
            return Float(self.double * other.double)
        }
    }
    public func divided(by other: any Scalar) -> Float {
        if other is Float {
            return self / (other as! Float)
        } else {
            return Float(self.double / other.double)
        }
    }
    public func power(_ exponent: Int) -> Float {
        Float(pow(double, Double(exponent)))
    }
}

//@available(iOS 14.0, *, macOS 11.0, *)
//extension Float16: Scalar {
//    public static var sType: ScalarType { .float16 }
//    public static var min: Float16 { -.greatestFiniteMagnitude }
//    public static var max: Float16 { .greatestFiniteMagnitude }
//    public var abs: Float16 { magnitude }
//    public var isNegative: Bool { self < 0 }
//    public var double: Double { Double(self) }
//}

extension Fraction: Scalar {
    public static var staticType: ScalarType { .fraction }
    public var sType: ScalarType { .fraction }
    static var min: Fraction { Fraction(integerLiteral: -Int.max) }
    static var max: Fraction { Fraction(integerLiteral: Int.max) }
    
    var isFinite: Bool { !isInfinite }
    var isNaN: Bool { numerator == 0 && isFinite }
    var double: Double {
        Double(whole) + doubleDecimal
    }
    
    public func equals(_ other: any Scalar) -> Bool {
        guard other is Fraction else { return false }
        return self == other as! Fraction
    }
    public func lessThan(_ other: any Scalar) -> Bool {
        if other is Float {
            return self < (other as! Fraction)
        } else {
            return double < other.double
        }
    }
    public func plus(_ other: any Scalar) -> Fraction {
        if other is Fraction {
            return self + (other as! Fraction)
        } else {
            return Fraction(double + other.double)
        }
    }
    public func multiplied(by other: any Scalar) -> Fraction {
        if other is Fraction {
            return self * (other as! Fraction)
        } else {
            return Fraction(self.double * other.double)
        }
    }
    public func divided(by other: any Scalar) -> Fraction {
        if other is Fraction {
            return self / (other as! Fraction)
        } else {
            return Fraction(self.double / other.double)
        }
    }
    func power(_ exponent: Int) -> Fraction {
        Fraction(numerator: numerator.power(exponent), denominator: denominator.power(exponent))
    }
    public var ln: Fraction { Fraction(Darwin.log(double)) }
    public var log2: Fraction { Fraction(Darwin.log2(double)) }
    func logx(x: any Scalar) -> Fraction {
        #warning("Loss of exactness")
        return Fraction(Darwin.log2(double) / Darwin.log2(x.double))
    }
}

/*
 extension Int: Finite {
 public static var min: Int { -.max }
 //public static var max: Int { Int.max }
 }
 
 extension Int8: Finite {
 public static var min: Int8 { -.max }
 // public static var max: Int8 { .max }
 }
 
 extension Int16: Finite {
 public static var min: Int16 { -.max }
 //public static var max: Int16 { .max }
 }
 
 extension Int32: Finite {
 public static var min: Int32 { -.max }
 //public static var max: Int32 { .max }
 }
 
 extension Int64: Finite {
 public static var min: Int64 { -.max }
 //public static var max: Int64 { .max }
 }
 */
