import Foundation

//public struct PiecewisePiece<P: Scalar> {
//    var range: ClosedRange<P>
//    var expression: any Expression
//
//    init(range: ClosedRange<P>, expression: any Expression) {
//        self.range = range
//        self.expression = expression
//    }
//
//    init(constant: P) {
//        self.range = P.min...P.max
//        self.expression = Polynomial(standardCoefficients: constant)
//    }
//}
//
//extension PiecewisePiece: Hashable, Comparable {
//
//    public static func == (lhs: PiecewisePiece<P>, rhs: PiecewisePiece<P>) -> Bool {
//        return lhs.range == rhs.range &&
//        lhs.expression.equals(rhs.expression)
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(range)
//        expression.hash(into: &hasher)
//    }
//
//    public static func < (lhs: PiecewisePiece<P>, rhs: PiecewisePiece<P>) -> Bool {
//        lhs.range.upperBound < rhs.range.upperBound
//    }
//}
//
//extension PiecewisePiece: CustomStringConvertible {
//    public var description: String {
//        "When x in \(range.description), \(expression.description)"
//    }
//}
//
//extension PiecewisePiece: AdditiveArithmetic {
//    public static var zero: PiecewisePiece<P> {
//        PiecewisePiece(range: P.min...(P.max), expression: Polynomial<P>.zero)
//    }
//
//    public static func + (lhs: PiecewisePiece<P>, rhs: PiecewisePiece<P>) -> PiecewisePiece<P> {
//        guard lhs.range == rhs.range else {
//            fatalError("Cannot add PiecewiseExpressions with different ranges: lhs \(lhs.range) and rhs \(rhs.range).")
//        }
//        let sumExpression = lhs.expression.adding(rhs.expression)
//        return PiecewisePiece(range: lhs.range, expression: sumExpression)
//    }
//
//    public mutating func negate() {
//        expression.negate()
//    }
//
//    public func negated() -> Self {
//        var negative = self
//        negative.negate()
//        return negative
//    }
//
//    public static func - (lhs: PiecewisePiece<P>, rhs: PiecewisePiece<P>) -> PiecewisePiece<P> {
//        return lhs + rhs.negated()
//    }
//}
//
//extension PiecewisePiece: ExpressibleByIntegerLiteral {
//    public typealias IntegerLiteralType = Int
//
//    public init(integerLiteral value: Int) {
//        self.init(range: P.min...P.max, expression: Polynomial<P>(standardCoefficients: P(exactly: value)!))
//    }
//}
//
//extension PiecewisePiece: Numeric, SignedNumeric {
//    public typealias Magnitude = Self
//
//    public var magnitude: PiecewisePiece<P> {
//        PiecewisePiece(range: range, expression: expression.magnitude as! any Expression) // this might be a problem if not all expressions use magnitude this way
//    }
//
//    public init?<T>(exactly source: T) where T : BinaryInteger {
//        self.init(constant: P(exactly: source)!)
//    }
//
//    public static func * (lhs: PiecewisePiece<P>, rhs: PiecewisePiece<P>) -> PiecewisePiece<P> {
//        let newRange = lhs.range.intersection(with: rhs.range)
//        return PiecewisePiece(range: newRange, expression: lhs.expression.multipliedBy(rhs.expression))
//    }
//
//    public static func *= (lhs: inout PiecewisePiece<P>, rhs: PiecewisePiece<P>) {
//        lhs = lhs * rhs
//    }
//}
//
//extension PiecewisePiece: Expression {
//
//    public typealias N = P
//
//    public func eval(x: P) -> P {
//        range.contains(x) ? expression.eval(x: x) as! P : P.zero
//    }
//
//    public func eval(x: any Scalar) -> P {
//        guard x is P else {
//            fatalError("Cannot evaluate x of type \(type(of: x)) on piecewise \(type(of: self)).")
//        }
//        return eval(x: x as! P)
//    }
//
//    public func lessThan(_ other: any Expression) -> Bool {
//        guard other is PiecewisePiece<N> else { return true }
//        let otherPiecewise = other as! PiecewisePiece<N>
//        let upper = range.upperBound
//        let otherUpper = otherPiecewise.range.upperBound
//        if upper == otherUpper {
//            return eval(x: upper) < otherPiecewise.eval(x: otherUpper)
//        }
//        return range.upperBound < otherPiecewise.range.upperBound
//    }
//
//    public func equals(_ other: any Expression) -> Bool {
//        guard other is PiecewisePiece<N> else { return false }
//        let otherPiecewise = other as! PiecewisePiece<N>
//        return range == otherPiecewise.range &&
//        expression.equals(otherPiecewise.expression)
//    }
//
//    public func adding(_ other: any Expression) -> any Expression {
//        guard other is PiecewisePiece<N> else {
//            fatalError("Must wrap expressions: Cannot add Piecewise self \(type(of: self)) and other \(type(of: other)) as expressions.")
//        }
//        let otherPiecewise = other as! PiecewisePiece<N>
//        guard range == otherPiecewise.range else {
//            fatalError("Must wrap expressions: Cannot add Piecewise self with range \(range) and other with range \(otherPiecewise.range).")
//        }
//        let sumExpression = expression.adding(otherPiecewise.expression)
//        return PiecewisePiece(range: range, expression: sumExpression)
//    }
//
//    public func multipliedBy(_ other: any Expression) -> any Expression {
//        let productExpression = expression.multipliedBy(other)
//        return PiecewisePiece(range: range, expression: productExpression)
//    }
//}

//public func equals(_ other: any Function) -> Bool {
//    guard other is Piecewise<P> else { return false }
//    return self == other as! Piecewise<P>
//}
