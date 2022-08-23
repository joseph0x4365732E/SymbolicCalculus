import Foundation

// MARK: Polynomial struct

public struct Polynomial<C: Finite> {
    public var coefficientsByPower: [C:C]
    public struct Nomial<N: Finite>: Hashable {
        var power: N
        var coefficient: N
    }
    
    public var terms: [Nomial<C>] {
        coefficientsByPower.sorted { lhs, rhs in
            lhs.key > rhs.key
        }.map { (power, coef) in
            Nomial(power: power, coefficient: coef)
        }
    }
    public var powers: [C] { Array(coefficientsByPower.keys) }
    public var largestPower: C { powers.max() ?? C.zero }
    
    public init(coefficientsByPower: [C:C]) {
        self.coefficientsByPower = coefficientsByPower
        removeZeroTerms()
    }
    
    public init(standardCoefficients: C...) {
        let enumerated:[(C,C)] = standardCoefficients.reversed().enumerated().map { (offset, element) in
            (C(exactly: offset)!, element)
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
        if #available(iOS 14.0, *, macOS 11.0, *) {
                if lhs is Float16 {
                    return (lhs as! Float16) / (rhs as! Float16) as! C
                }
        }
        switch lhs {
        case is Double :
            return (lhs as! Double) / (rhs as! Double) as! C
        case is Float:
            return (lhs as! Float) / (rhs as! Float) as! C
//            case is Float16:
//                return (lhs as! Float16) / (rhs as! Float16) as! C
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

// MARK: Poly: Hashable Comparable
extension Polynomial: Hashable, Comparable {
    public static func < (lhs: Polynomial<C>, rhs: Polynomial<C>) -> Bool {
        lhs.largestPower < rhs.largestPower
    }
}

// MARK: Poly: CustomStringConvertible
extension Polynomial: CustomStringConvertible {
    public var description: String {
        coefficientsByPower.sorted { lhs, rhs in
            lhs.key > rhs.key
        }.map { (power, coef) in
            "\(coef)x^\(power)"
        }.joined(separator: " + ")
    }
}

// MARK: Poly: AdditiveArithmetic +-
extension Polynomial: AdditiveArithmetic  {
    public static var zero: Polynomial<C> {
        Polynomial<C>(coefficientsByPower: [:])
    }
    
    public static func + (lhs: Polynomial<C>, rhs: Polynomial<C>) -> Polynomial<C> {
        let newCoefs = lhs.coefficientsByPower.merging(rhs.coefficientsByPower) { coef1, coef2 in
            coef1 + coef2
        }
        var newPoly = Polynomial(coefficientsByPower: newCoefs)
        newPoly.removeZeroTerms()
        return newPoly
    }

    public mutating func negate() {
        coefficientsByPower.forEach { (power, coef) in
            coefficientsByPower[power] = -coef
        }
    }
    
    public mutating func negated() -> Polynomial<C> {
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

// MARK: Poly: Expressible by Int
extension Polynomial: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(standardCoefficients: value as! C)
        removeZeroTerms()
    }
}

// MARK: Poly: Numeric mag, *, init
extension Polynomial: Numeric, SignedNumeric {
    public typealias Magnitude = Polynomial<C>

    public var magnitude: Polynomial<C> {
        let newCoefTupes = coefficientsByPower.map { (power, coef) in
            (power, abs(coef))
        }
        let newCoef = Dictionary(uniqueKeysWithValues: newCoefTupes)
        return Polynomial(coefficientsByPower: newCoef)
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        assert(source is C, "BinaryInteger to initialized from \(type(of: source)) to match exactly \(C.self).")
        coefficientsByPower = [T.zero as! C: source as! C]
        removeZeroTerms()
    }

    public static func * (lhs: Polynomial<C>, rhs: Polynomial<C>) -> Polynomial<C> {
        let tuples: [(C,C)] = lhs.coefficientsByPower.flatMap { (lhsPower, lhsCoef) in
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
    
    public static func *= (lhs: inout Polynomial, rhs: Polynomial) {
        lhs = lhs * rhs
    }
}

// MARK: Polynomial: Expression
extension Polynomial: Expression {
    public typealias N = C
    
    // MARK: Poly: eval(x)
    public func eval(x: any Finite) -> N {
        if #available(iOS 14.0, *, macOS 11.0, *) {
            if x is Float16 {
                let xFloat = Float(x as! Float16)
                let addends = (coefficientsByPower as! [Float16:Float16]).map { (power, coef) in
                    Float(coef) * pow(xFloat, Float(power))
                }
                return Float16(addends.reduce(0.0, +)) as! C
            }
        }
        
        switch x {
        case is Double :
            let xDouble = x as! Double
            let addends = (coefficientsByPower as! [Double:Double]).map { (power, coef) in
                coef * pow(xDouble, power)
            }
            return addends.reduce(0.0, +) as! C
        case is Float:
            let xFloat = x as! Float
            let addends = (coefficientsByPower as! [Float:Float]).map { (power, coef) in
                coef * pow(xFloat, power)
            }
            return addends.reduce(0.0, +) as! C
//        case is Float16:
//            let xFloat = Float(x as! Float16)
//            let addends = (coefficientsByPower as! [Float16:Float16]).map { (power, coef) in
//                Float(coef) * pow(xFloat, Float(power))
//            }
//            return Float16(addends.reduce(0.0, +)) as! C
//        case is Float80:
//            let xFloat16 = x as! Float
//            let addends = (coefficientsByPower as! [Float16:Float16]).map { (power, coef) in
//                coef * pow(xFloat16, power)
//            }
//            return addends.reduce(0.0, +)
        case is Int:
            let xDouble = Double(x as! Int)
            let addends = (coefficientsByPower as! [Int:Int]).map { (power, coef) in
                Double(coef) * pow(xDouble, Double(power))
            }
            return Int(addends.reduce(0.0, +)) as! C
        case is Int16:
            let xFloat = Float(x as! Int16)
            let addends = (coefficientsByPower as! [Int16:Int16]).map { (power, coef) in
                Float(coef) * pow(xFloat, Float(power))
            }
            return Int16(addends.reduce(0.0, +)) as! C
        case is Int32:
            let xDouble = Double(x as! Int32)
            let addends = (coefficientsByPower as! [Int32:Int32]).map { (power, coef) in
                Double(coef) * pow(xDouble, Double(power))
            }
            return Int32(addends.reduce(0.0, +)) as! C
        case is Int64:
            let xDecimal = Decimal(x as! Int64)
            let addends = (coefficientsByPower as! [Int64:Int64]).map { (power, coef) in
                Decimal(coef) * pow(xDecimal, Int(power))
            }
            return (addends.reduce(0.0, +) as NSDecimalNumber).int64Value as! C
        case is Int8:
            let xFloat = Float(x as! Int8)
            let addends = (coefficientsByPower as! [Int8:Int8]).map { (power, coef) in
                Float(coef) * pow(xFloat, Float(power))
            }
            return Int8(addends.reduce(0.0, +)) as! C
        default :
            fatalError("Unsupported SignedInteger type \(type(of: x)) for Polynomial.")
        }
    }
    
    // MARK: lessThan(other)
    public func lessThan(_ other: any Expression) -> Bool {
        guard other is Polynomial<C> else { return false }
        return self < (other as! Polynomial<C>)
    }
    
    // MARK: equals(other Func)
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Polynomial<C> else { return false }
        return self == other as! Polynomial<C>
    }
    
    public func adding(_ other: any Expression) -> any Expression {
        guard other is Polynomial<C> else {
            fatalError("Cannot add type \(type(of: other)) to \(Self.self).")
        }
        return self + (other as! Polynomial<C>)
    }
    
    public func multipliedBy(_ other: any Expression) -> any Expression {
        guard other is Polynomial<C> else {
            fatalError("Cannot multiply self of type \(type(of: self)) by other of type \(type(of: other)).")
        }
        return self * (other as! Polynomial<C>)
    }
}

extension Polynomial: Differentiable {
    public func nthDerivative(n: C) -> any Expression {
        let tuples = coefficientsByPower.filter({ (power, coef) in
            power != 0 // constant terms have a derivative of 0.
        }).map { (power, coef) in
            let newCoef = coef * power
            let newPower = power - 1
            return (newPower, newCoef)
        }
        return Polynomial(coefficientsByPower: Dictionary(uniqueKeysWithValues: tuples))
    }
}

extension Polynomial: Integrable {
    public func nthIntegral(n: C) -> any Expression {
        let tuples = coefficientsByPower.map { (power, coef) in
            let newPower = power + 1
            let newCoef = Polynomial<C>.divide(coef, by: newPower)
            return (newPower, newCoef)
        }
        return Polynomial(coefficientsByPower: Dictionary(uniqueKeysWithValues: tuples))
    }
}
