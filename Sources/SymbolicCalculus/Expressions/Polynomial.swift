import Foundation

// MARK: Polynomial struct

public struct Polynomial<C: Scalar> {
    public var coefficientsByPower: [Int:C]
    
    public struct Nomial<N: Scalar>: Hashable {
        var power: Int
        var coefficient: N
    }
    
    public var terms: [Nomial<C>] {
        coefficientsByPower.sorted { lhs, rhs in
            lhs.key > rhs.key
        }.map { (power, coef) in
            Nomial(power: power, coefficient: coef)
        }
    }
    
    public var coefficients: [C] { Array(coefficientsByPower.values) }
    public var powers: [Int] { Array(coefficientsByPower.keys).sorted(by: >) }
    public var largestPower: Int { powers.max() ?? 0 }
    public var smallestPower: Int { powers.min() ?? 0 }
    public var mostNegativePower: Int? {
        guard let min = powers.min() else { return nil }
        return (min < 0) ? min : nil
    }
    public var firstCoefficient: C { coefficientsByPower[largestPower] ?? C.zero }
    public var constant: C? { coefficientsByPower[0] }
    public var hasConstant: Bool { coefficientsByPower[0] != nil }
    
    public init(coefficientsByPower: [Int:C]) {
        self.coefficientsByPower = coefficientsByPower
        removeZeroTerms()
    }
    
    public init(standardCoefficients: C...) {
        let enumerated:[(Int,C)] = standardCoefficients.reversed().enumerated().map { (offset, element) in
            (offset, element)
        }
        let coef = Dictionary(uniqueKeysWithValues: enumerated)
        coefficientsByPower = coef
        removeZeroTerms()
    }
    
    private mutating func removeZeroTerms() {
        coefficientsByPower = coefficientsByPower.filter { (_, coef) in
            coef != .zero
        }
    }
    
    // MARK: divide(c,c)
    static func divide(_ lhs: C, by rhs: C) -> C {
//        if #available(iOS 14.0, *, macOS 11.0, *) {
//                if lhs is Float16 {
//                    return (lhs as! Float16) / (rhs as! Float16) as! C
//                }
//        }
        switch lhs {
        case is Double :
            return (lhs as! Double) / (rhs as! Double) as! C
        case is Float:
            return (lhs as! Float) / (rhs as! Float) as! C
        case is Int:
            return (lhs as! Int) / (rhs as! Int) as! C
        case is Int16:
            return (lhs as! Int16) / (rhs as! Int16) as! C
        case is Int32:
            return (lhs as! Int32) / (rhs as! Int32) as! C
        case is Int64:
            return (lhs as! Int64) / (rhs as! Int64) as! C
        case is Int8:
            return (lhs as! Int8) / (rhs as! Int8) as! C
        default :
            fatalError("Unsupported SignedInteger type \(type(of: lhs)) for Polynomial.")
        }
    }
}

// MARK: Poly: CustomStringConvertible
extension Polynomial: Hashable, CustomStringConvertible {
    public var description: String {
        coefficientsByPower.sorted { lhs, rhs in
            lhs.key > rhs.key
        }.map { (power, coef) in
            "\(coef)x^\(power)"
        }.joined(separator: " + ")
    }
}

extension Polynomial: Boundable {
    public typealias N = C
    
    public var min: C {
        Swift.min(limPosInf ?? .infinity, limNegInf ?? .infinity, limFromPosToZero, limFromNegToZero)
    }
    public var max: C {
        Swift.max(limPosInf ?? -C.infinity, limNegInf ?? -C.infinity, limFromPosToZero, limFromNegToZero)
    }
}

extension Polynomial: Expression {
    public func eval(x: any Scalar) -> any Scalar {
        guard x is C else { fatalError("Cannot evaluate \(type(of: self)) with x of type \(x.sType).") }
        return eval(x: x as! C)
    }
    
    public var eType: ExpressionType { .polynomial(sType: C.staticType) }
    public var resolved: Bool { true }
    
    //MARK: Lim x -> a
    var limPosInf: C? {
        if largestPower > 0 {
            // limit is infinite
            return firstCoefficient.isNegative ? -C.infinity : .infinity
        } else {
            // all negative powers will converge to 0
            return firstCoefficient
        }
    }
    
    var limNegInf: C? {
        if largestPower > 0 {
            // limit is infinite or does not exist
            let test = pow(-1.1, Double(largestPower))
            if test.isNaN {
                return nil
            } else {
                return test.isNegative ? -C.infinity : .infinity
            }
        } else {
            return firstCoefficient
        }
    }
    
    var limAtZeroFinite: Bool { (mostNegativePower ?? 0) < 0 }
    
    private func limToZero(testing: Double) -> C {
        if limAtZeroFinite {
            return eval(x: C.zero)
        } else {
            let test = pow(testing, Double(mostNegativePower!))
            return test.isNegative ? -C.infinity : .infinity
        }
    }
    
    var limFromPosToZero: C { limToZero(testing: 0.1) }
    
    var limFromNegToZero: C { limToZero(testing: -0.1) }
    
    var isConstant: Bool {
        largestPower == 0 && powers.count == 1
    }
    
    // MARK: eval(x)
    public func eval(x: C) -> C {
//        if #available(iOS 14.0, *, macOS 11.0, *) {
//            if x is Float16 {
//                let xFloat = Float(x as! Float16)
//                let addends = (coefficientsByPower as! [Float16:Float16]).map { (power, coef) in
//                    Float(coef) * pow(xFloat, Float(power))
//                }
//                return Float16(addends.sum) as! C
//            }
//        }
        
        switch x {
        case is Double :
            let xDouble = x as! Double
            let addends = (coefficientsByPower as! [Double:Double]).map { (power, coef) in
                coef * pow(xDouble, power)
            }
            return addends.sum as! C
        case is Float:
            let xFloat = x as! Float
            let addends = (coefficientsByPower as! [Float:Float]).map { (power, coef) in
                coef * pow(xFloat, power)
            }
            return addends.sum as! C
        case is Int:
            let xDouble = Double(x as! Int)
            let addends = (coefficientsByPower as! [Int:Int]).map { (power, coef) in
                Double(coef) * pow(xDouble, Double(power))
            }
            return Int(addends.reduce(0.0, +)) as! C
        default :
            fatalError("Unsupported SignedInteger type \(type(of: x)) for Polynomial.")
        }
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Self else { return false }
        return (other as! Self) == self
    }
    
    public func multiplied(by other: any Expression) -> any Expression {
        guard other is Self else { fatalError("Can't multiply Polynomial by other expression type \(other.eType).") }
        return (other as! Self) * self
    }
    public func power(_ exponent: Int) -> Polynomial<C> {
        var mutableSelf:Polynomial<C> = 1
        for _ in 0..<Swift.abs(exponent) {
            mutableSelf = mutableSelf * self
        }
        return (exponent < 0) ? mutableSelf.reciprocal : mutableSelf
    }
//    public func nthDerivative(n: C) -> any Expression {
//        let tuples = coefficientsByPower.filter({ (power, coef) in
//            power != 0 // constant terms have a derivative of 0.
//        }).map { (power, coef) in
//            let newCoef = coef * C(exactly: power)!
//            let newPower = power - 1
//            return (newPower, newCoef)
//        }
//        return Polynomial(coefficientsByPower: Dictionary(uniqueKeysWithValues: tuples))
//    }
//    public func nthIntegral(n: C) -> any Expression {
//        let tuples = coefficientsByPower.map { (power, coef) in
//            let newPower = power + 1
//            let newCoef = Polynomial<C>.divide(coef, by: C(exactly: newPower)!)
//            return (newPower, newCoef)
//        }
//        return Polynomial(coefficientsByPower: Dictionary(uniqueKeysWithValues: tuples))
//    }
    
    public func simplified() -> any Expression { self }
    public var abs: any Expression {
        let newCoefTupes = coefficientsByPower.map { (power, coef) in
            (power, Swift.abs(coef))
        }
        let newCoef = Dictionary(uniqueKeysWithValues: newCoefTupes)
        return Polynomial(coefficientsByPower: newCoef)
    }
}

// MARK: Poly.zero
extension Polynomial: Zeroable {
    public static var zero: Polynomial<C> {
        Polynomial<C>(coefficientsByPower: [:])
    }
}

// MARK: Poly(Int)
extension Polynomial: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(standardCoefficients: C(exactly: value)!)
        removeZeroTerms()
    }
}

// MARK: Poly + Poly
extension Polynomial: Addable {
    public static func + (lhs: Polynomial<C>, rhs: Polynomial<C>) -> Polynomial<C> {
        let newCoefs = lhs.coefficientsByPower.merging(rhs.coefficientsByPower) { coef1, coef2 in
            coef1 + coef2
        }
        var newPoly = Polynomial(coefficientsByPower: newCoefs)
        newPoly.removeZeroTerms()
        return newPoly
    }
    public func plus(_ other: Polynomial<C>) -> Polynomial<C> {
        self + other
    }
}

// MARK: Poly - Poly
extension Polynomial: Negatable  {
    public mutating func negate() {
        coefficientsByPower.forEach { (power, coef) in
            coefficientsByPower[power] = -coef
        }
    }
    
    public func negated() -> Polynomial<C> {
        var negative = self
        negative.negate()
        return negative
    }

    public static func - (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        var negative = rhs
        negative.negate()
        return lhs + negative
    }
}

// MARK: Poly * Poly
extension Polynomial: Multipliable {
    public static func * (lhs: Polynomial<C>, rhs: Polynomial<C>) -> Polynomial<C> {
        let tuples: [(Int,C)] = lhs.coefficientsByPower.flatMap { (lhsPower, lhsCoef) in
            return rhs.coefficientsByPower.map { (rhsPower, rhsCeof) in
                return (lhsPower + rhsPower, lhsCoef * rhsCeof) // multiply coefficients and add powers
            }
        }
        print("tuples \(tuples)")
        let finalCoeffientsByPowers = Dictionary(tuples) { (lhsCoef, rhsCoef) in
            lhsCoef + rhsCoef
        }
        print("finalCoeffientsByPowers \(finalCoeffientsByPowers)")
        return Polynomial(coefficientsByPower: finalCoeffientsByPowers)
    }
}

// MARK: reciprocal
extension Polynomial: Reciprocable {
    public var reciprocal: Polynomial<C> {
        let tuples = coefficientsByPower.map { power, coefficient in
            (-power, Polynomial<C>.divide(1, by: coefficient))
        }
        let newCoefsByPower = Dictionary(uniqueKeysWithValues: tuples)
        return Polynomial(coefficientsByPower: newCoefsByPower)
    }
}

// MARK: zeros
extension Polynomial where C == Fraction {
    
    var possibleZeros: [C] {
        let frac = (smallestPower / firstCoefficient).simplified
        let numFactors = frac.numerator.uniqueFactors
        let denomFactors = frac.denominator.uniqueFactors
        
        let possiblities = numFactors.flatMap { numerator in
            denomFactors.map { denom in
                Fraction(numerator: numerator, denominator: denom)
            }
        }
        let zeroAddition:[C] = hasConstant ? [] : [0]
        return possiblities + zeroAddition
    }
}
