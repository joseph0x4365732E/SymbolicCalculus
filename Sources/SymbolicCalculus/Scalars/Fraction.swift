//
//  Fraction.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation
import BigInt

struct Fraction {
    var isInfinite = false
    var sign: BigInt.Sign
    var numerator: BigUInt
    var denominator: BigUInt
    
    init(isInfinite: Bool = false, sign: BigInt.Sign = .plus, numerator: BigUInt, denominator: BigUInt) {
        self.isInfinite = isInfinite
        self.sign = sign
        self.numerator = numerator
        self.denominator = denominator
    }
    
    init(numerator: BigInt, denominator: BigInt) {
        let signsTheSame = numerator.sign == denominator.sign
        self.sign = signsTheSame ? .plus : .minus
        self.numerator = numerator.magnitude
        self.denominator = denominator.magnitude
    }
    
    init(_ double: Double) {
        self.sign = double.isNegative ? .minus : .plus
        self.numerator = BigUInt(double.significandBitPattern) * BigUInt(2).power(double.exponent)
        self.denominator = BigUInt(2).power(52)
        
    }
    
    var doubleDecimal: Double {
        Double(numerator % denominator) / Double(denominator)
    }
    
    var simplified: Fraction {
        let gcd = numerator.greatestCommonDivisor(with: denominator)
        return Fraction(numerator: numerator / gcd, denominator: denominator / gcd)
    }
    
    var whole: BigInt {
        BigInt(sign: sign, magnitude: numerator / denominator)
    }
    
    public var isWhole: Bool { simplified.denominator == 1 }
    
    var factorial: Fraction {
        guard isWhole else { return .nan }
        guard self <= 1000 else { return .infinity }
        let newNumerator = (2...Int(numerator)).map { BigUInt($0) }.product
        return Fraction(numerator: newNumerator, denominator: 1)
    }
    
    // MARK: GCD
    static func gcd(_ lhs: Fraction, _ rhs: Fraction) -> Fraction {
        if (lhs == 0) && (rhs == 0) { return max }
        if lhs == 0 { return rhs }
        if rhs == 0 { return lhs }
        
        let num = lhs.numerator.greatestCommonDivisor(with: rhs.numerator)
        let denom = lhs.denominator.greatestCommonDivisor(with: rhs.denominator)
        return Fraction(numerator: num, denominator: denom).simplified
    }
    
    static func gcd(_ fractions: [Fraction]) -> Fraction {
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
    static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        if lhs.whole < rhs.whole { return true }
        if lhs.whole > rhs.whole { return false }
        return lhs.doubleDecimal < rhs.doubleDecimal
    }
}

// MARK: String
extension Fraction: CustomStringConvertible {
    public var description: String {
        let sim = simplified
        return "(\(sim.numerator)/\(sim.denominator))"
    }
}

// MARK: Int Literal
extension Fraction: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: Int) {
        sign = (value < 0) ? .minus : .plus
        numerator = BigUInt(value.magnitude)
        denominator = 1
    }
}

// MARK: Add Subtract Multiply
extension Fraction: AdditiveArithmetic, SignedNumeric {
    static var zero: Fraction {
        Fraction(numerator: 0, denominator: 1)
    }
    
    static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        let newDenom = lhs.denominator.greatestCommonDivisor(with: rhs.denominator)
        let lhsMultiplier = newDenom / lhs.denominator
        let rhsMultiplier = newDenom / rhs.denominator
        let lhsNewNumerator = lhs.numerator * lhsMultiplier
        let rhsNewNumerator = rhs.numerator * rhsMultiplier
        var newNumerator = lhsNewNumerator + rhsNewNumerator
        return Fraction(numerator: newNumerator, denominator: newDenom)
    }
    
    mutating func negate() {
        sign = (sign == .minus) ? .plus : .minus
    }
    
    func negated() -> Fraction {
        var mutable = self
        mutable.negate()
        return mutable
    }
    
    static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
        lhs + rhs.negated()
    }
    
    typealias Magnitude = Fraction
    
    var magnitude: Fraction {
        return Fraction(numerator: numerator, denominator: denominator)
    }
    
    init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(integerLiteral: Int(source))
    }
    
    static func * (lhs: Int, rhs: Fraction) -> Fraction {
        return Fraction(numerator: BigInt(lhs) * BigInt(rhs.numerator), denominator: BigInt(rhs.denominator))
            .simplified
    }
    
    static func * (lhs: Fraction, rhs: Int) -> Fraction {
        rhs * lhs
    }
    
    static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
            .simplified
    }
    
    static func *= (lhs: inout Fraction, rhs: Fraction) {
        lhs = lhs * rhs
    }
}

// MARK: Divide
extension Fraction: Divisible {
    
    static func / (lhs: Fraction, rhs: Int) -> Fraction {
        Fraction(numerator: lhs.numerator, denominator: lhs.denominator * BigUInt(rhs))
            .simplified
    }
    
    
    static func / (lhs: Int, rhs: Fraction) -> Fraction {
        Fraction(numerator: BigUInt(lhs) * rhs.denominator, denominator: rhs.numerator)
            .simplified
    }
    
    static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
        (lhs * rhs.reciprocal).simplified
    }
    
    func isMultiple(of: Self) -> Bool { true }
    
    func quotientAndRemainder(dividingBy rhs: Fraction) -> (quotient: Fraction, remainder: Fraction) {
        (self / rhs, 0)
    }
    
    static func % (lhs: Fraction, rhs: Fraction) -> Fraction { .zero }
}

// MARK: Reciprocal
extension Fraction: Reciprocable {
    var reciprocal: Fraction {
        Fraction(numerator: denominator, denominator: numerator)
            .simplified
    }
}

// MARK: Static values
extension Fraction {
    static var infinity: Fraction { return Fraction(isInfinite: true, numerator: 69420, denominator: 0) }
    static var nan: Fraction { Fraction(numerator: 1, denominator: 0) }
}
