//
//  Fraction.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation
import BigInt

public struct Fraction {
    public var isInfinite = false
    public var sign: BigInt.Sign
    public var numerator: BigUInt
    public var signedNumerator: BigInt { BigInt(sign: sign, magnitude: numerator) }
    public var denominator: BigUInt
    
    public init(isInfinite: Bool = false, sign: BigInt.Sign = .plus, numerator: BigUInt, denominator: BigUInt) {
        self.isInfinite = isInfinite
        self.sign = sign
        self.numerator = numerator
        self.denominator = denominator
    }
    
    public init(whole: BigInt) {
        self.sign = whole.sign
        self.numerator = whole.magnitude
        self.denominator = 1
    }
    
    public init(numerator: BigInt, denominator: BigInt) {
        let signsTheSame = numerator.sign == denominator.sign
        self.sign = signsTheSame ? .plus : .minus
        self.numerator = numerator.magnitude
        self.denominator = denominator.magnitude
    }
    
    public init?(_ string: String) {
        guard !string.isEmpty else { return nil }
        
        guard string.contains("/") else {
            guard let num = BigInt(string) else { return nil }
            self.init(whole: num)
            return
        }
        
        let slashIndex = string.firstIndex(of: "/")!
        let numStr = string[...slashIndex]
        let denStr = string[slashIndex...]
        
        guard let num = BigInt(numStr) else  { return nil }
        guard let denom = BigInt(denStr) else { return nil }
        
        self.init(numerator: num, denominator: denom)
    }
    
    public init(_ double: Double) {
        let tempSign:BigInt.Sign = double.isNegative ? .minus : .plus
        
        let tempNum =  BigUInt(double.significandBitPattern) * BigUInt(2).power(double.exponent)
        let numSigned = BigInt(sign: tempSign, magnitude: tempNum)
        let tempDenom: BigInt = BigInt(2).power(52)
        self = Fraction(numerator: numSigned, denominator: tempDenom).simplified
    }
    
    public var doubleDecimal: Double {
        Double(numerator % denominator) / Double(denominator)
    }
    
    public var simplified: Fraction {
        let gcd = numerator.greatestCommonDivisor(with: denominator)
        return Fraction(numerator: numerator / gcd, denominator: denominator / gcd)
    }
    
    public var whole: BigInt {
        BigInt(sign: sign, magnitude: numerator / denominator)
    }
    
    public var isWhole: Bool { simplified.denominator == 1 }
    
    public var factorial: Fraction {
        guard isWhole else { return .nan }
        guard self <= 1000 else { return .infinity }
        if self == 1 { return self }
        let newNumerator = (2...Int(numerator)).map { BigUInt($0) }.product
        return Fraction(numerator: newNumerator, denominator: 1)
    }
    
    // MARK: GCD
    public static func gcd(_ lhs: Fraction, _ rhs: Fraction) -> Fraction {
        if (lhs == 0) && (rhs == 0) { return max }
        if lhs == 0 { return rhs }
        if rhs == 0 { return lhs }
        
        let num = lhs.numerator.greatestCommonDivisor(with: rhs.numerator)
        let denom = lhs.denominator.greatestCommonDivisor(with: rhs.denominator)
        return Fraction(numerator: num, denominator: denom).simplified
    }
    
    public static func gcd(_ fractions: [Fraction]) -> Fraction {
        guard !fractions.isEmpty else {
            return 1
        }
        
        var gcdSoFar = fractions.first!
        fractions.dropFirst(1).forEach {
            gcdSoFar = Fraction.gcd(gcdSoFar, $0)
        }
        return gcdSoFar
    }
}

// MARK: Hash, Compare
extension Fraction: Hashable, Comparable {
    public static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        if lhs.whole < rhs.whole { return true }
        if lhs.whole > rhs.whole { return false }
        return lhs.doubleDecimal < rhs.doubleDecimal
    }
}

// MARK: String
extension Fraction: CustomStringConvertible {
    public var description: String {
        let sim = simplified
        let signString = sign == .minus ? "-" : ""
        let magnitudeString = sim.isWhole ? String(sim.numerator): "(\(sim.numerator)/\(sim.denominator))"
        return signString + magnitudeString
    }
}

// MARK: Int Literal
extension Fraction: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        sign = (value < 0) ? .minus : .plus
        numerator = BigUInt(value.magnitude)
        denominator = 1
    }
}

// MARK: Add Subtract Multiply
extension Fraction: AdditiveArithmetic, SignedNumeric {
    public static var zero: Fraction {
        Fraction(numerator: 0, denominator: 1)
    }
    
    public static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        let newDenom:BigUInt = lhs.denominator.greatestCommonDivisor(with: rhs.denominator)
        let lhsMultiplier:BigUInt = newDenom / lhs.denominator
        let rhsMultiplier:BigUInt = newDenom / rhs.denominator
        let lhsNewNumerator:BigInt = lhs.signedNumerator * BigInt(lhsMultiplier)
        let rhsNewNumerator:BigInt = rhs.signedNumerator * BigInt(rhsMultiplier)
        var newNumerator:BigInt = lhsNewNumerator + rhsNewNumerator
        return Fraction(numerator: newNumerator, denominator: BigInt(newDenom))
    }
    
    public mutating func negate() {
        sign = (sign == .minus) ? .plus : .minus
    }
    
    public func negated() -> Fraction {
        var mutable = self
        mutable.negate()
        return mutable
    }
    
    public static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
        lhs + rhs.negated()
    }
    
    public typealias Magnitude = Fraction
    
    public var magnitude: Fraction {
        return Fraction(numerator: numerator, denominator: denominator)
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(integerLiteral: Int(source))
    }
    
    public static func * (lhs: Int, rhs: Fraction) -> Fraction {
        return Fraction(numerator: BigInt(lhs) * BigInt(rhs.numerator), denominator: BigInt(rhs.denominator))
            .simplified
    }
    
    public static func * (lhs: Fraction, rhs: Int) -> Fraction {
        rhs * lhs
    }
    
    public static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
            .simplified
    }
    
    public static func *= (lhs: inout Fraction, rhs: Fraction) {
        lhs = lhs * rhs
    }
}

// MARK: Divide
extension Fraction: Divisible {
    
    public static func / (lhs: Fraction, rhs: Int) -> Fraction {
        Fraction(numerator: lhs.numerator, denominator: lhs.denominator * BigUInt(rhs))
            .simplified
    }
    
    
    public static func / (lhs: Int, rhs: Fraction) -> Fraction {
        Fraction(numerator: BigUInt(lhs) * rhs.denominator, denominator: rhs.numerator)
            .simplified
    }
    
    public static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
        (lhs * rhs.reciprocal).simplified
    }
    
    public func isMultiple(of: Self) -> Bool { true }
    
    public func quotientAndRemainder(dividingBy rhs: Fraction) -> (quotient: Fraction, remainder: Fraction) {
        (self / rhs, 0)
    }
    
    public static func % (lhs: Fraction, rhs: Fraction) -> Fraction { .zero }
}

// MARK: Reciprocal
extension Fraction {
    public var reciprocal: Fraction {
        Fraction(numerator: denominator, denominator: numerator)
            .simplified
    }
}

// MARK: Static values
extension Fraction {
    public static var infinity: Fraction { return Fraction(isInfinite: true, numerator: 69420, denominator: 0) }
    public static var nan: Fraction { Fraction(numerator: 1, denominator: 0) }
}
