//
//  Expression.swift
//  
//
//  Created by Joseph Cestone on 8/17/22.
//

import Foundation

public protocol Boundable {
    associatedtype N: Scalar
    var min: N { get }
    var max: N { get }
}

extension Boundable {
    var bounds: ClosedRange<N> { min...max }
    var boundsAnyScalar: ClosedRange<AnyScalar> { AnyScalar(min)...AnyScalar(max) }
}

extension Boundable {
    var isNegative: Bool? {
        if max < 0 { return true } // must be negative
        if min >= 0 { return false } // must be positive
        return nil
    }
}

// MARK: UnaryOperator Protocols
//public protocol Absolutable { // All Expressions
//    var abs: any Expression { get }
//}

public protocol Reciprocable {
    #warning("Replace with divisible for any Expression")
    var reciprocal: Self { get }
}

#warning("Replace with Exponentiable")
//public protocol IntegerPowerable {
//    func power(_ exponent: Int) -> any Expression
//}

public protocol Expression: Hashable, CustomStringConvertible, Boundable {
    var eType: ExpressionType { get }
    func eval(x: any Scalar) -> any Scalar
    func equals(_ other: any Expression) -> Bool
    func equivalent(to other: any Expression) -> Bool
    
    func plus(_ other: any Expression) -> any Expression
    func multiplied(by other: any Expression) -> any Expression
    func divided(by other: any Expression) -> any Expression
    func power(_ other: any Expression) -> any Expression
    func logx(x: any Expression) -> any Expression
    func nthDerivative(n: any Expression) -> any Expression
    func nthIntegral(n: any Expression) -> any Expression
    
    var constant: AnyScalar? { get }
    func simplified() -> any Expression
    var abs: any Expression { get }
    var sqrt: any Expression { get }
    var ln: any Expression { get }
    var log2: any Expression { get }
    var log10: any Expression { get }
    func negated() -> any Expression
}

extension Expression {
    public func equals(_ other: any Expression) -> Bool {
        guard eType == other.eType else { return false }
        return self == (other as! Self)
    }
    public func equivalent(to other: any Expression) -> Bool { other.simplified().equals(other.simplified()) }
    
    public func plus(_ other: any Expression) -> any Expression { Sum(arg1: simplified(), arg2: other.simplified()) }
    public func multiplied(by other: any Expression) -> any Expression { Product(arg1: simplified(), arg2: other.simplified()) }
    public func divided(by other: any Expression) -> any Expression { Quotient(arg1: simplified(), arg2: other.simplified()) }
    public func power(_ other: any Expression) -> any Expression { Exponential(arg1: simplified(), arg2: other.simplified()) }
    public func logx(x: any Expression) -> any Expression { Logx(arg1: simplified(), arg2: x.simplified()) }
//    public func nthWholeDerivative(n: UInt) -> any Expression
//    public func nthWholeIntegral(n: UInt) -> any Expression
    public func nthDerivative(n: any Expression) -> any Expression { NthDerivative(arg1: simplified(), arg2: n.simplified()) }
    public func nthIntegral(n: any Expression) -> any Expression { NthIntegral(arg1: simplified(), arg2: n.simplified()) }
    
    public var constant: AnyScalar? { nil }
    public func simplified() -> any Expression { self }
    public var abs: any Expression { Abs(arg1: simplified()) }
    public var sqrt: any Expression { Sqrt(arg1: simplified()) }
    public var ln: any Expression { Ln(arg1: simplified()) }
    public var log2: any Expression { Log2(arg1: simplified()) }
    public var log10: any Expression { Log10(arg1: simplified()) }
    public func negated() -> any Expression { Negative(arg1: simplified()) }
    public var factorial: any Expression { Factorial(arg1: simplified()) }
}

//protocol BinaryOperation: Expression {
//    var arg1: any Expression { get set }
//    var arg2: any Expression { get set }
//}
//
//extension BinaryOperation {
//    
//}
