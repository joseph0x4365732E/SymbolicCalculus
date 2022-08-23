//
//  Expression.swift
//  
//
//  Created by Joseph Cestone on 8/17/22.
//

import Foundation

public protocol Expression: SignedNumeric, Hashable, Comparable, CustomStringConvertible {
    associatedtype N: Finite
    func eval(x: any Finite) -> N
    func lessThan(_ other: any Expression) -> Bool
    func equals(_ other: any Expression) -> Bool
    func adding(_ other: any Expression) -> any Expression
    func multipliedBy(_ other: any Expression) -> any Expression
    mutating func negated() -> Self
}

//public protocol Differentiable: Expression {
//    func nthDerivative(n: N) -> any Expression
//}
//
//public protocol Integrable: Expression {
//    func nthIntegral(n: N) -> any Expression
//}

final class ExpressionWrapper<Number: Finite>: Hashable {
    var expression: any Expression
    
    init(expression: any Expression) {
        self.expression = expression
    }
    
    func eval(x: Number) -> Number {
        func evalTyped<Exp: Expression, Num: Finite>(expr: Exp, x: Num) -> Number {
            assert(Exp.N.self is Num, "Expression type \(type(of: expr)) and number type \(type(of: x)) missmatch.")
            return expr.eval(x: x as! Exp.N) as! Number
        }
        
        if #available(iOS 14.0, *, macOS 11.0, *) {
            if expression is Polynomial<Float16> {
                return evalTyped(expr: expression as! Polynomial<Float16>, x: x)
            }
        }
        
        switch expression {
        case is Polynomial<Double>:
            return evalTyped(expr: expression as! Polynomial<Double>, x: x)
        case is Polynomial<Float>:
            return evalTyped(expr: expression as! Polynomial<Float>, x: x)
        case is Polynomial<Int>:
            return evalTyped(expr: expression as! Polynomial<Int>, x: x)
        case is Polynomial<Int64>:
            return evalTyped(expr: expression as! Polynomial<Int64>, x: x)
        case is Polynomial<Int32>:
            return evalTyped(expr: expression as! Polynomial<Int32>, x: x)
        case is Polynomial<Int16>:
            return evalTyped(expr: expression as! Polynomial<Int16>, x: x)
        case is Polynomial<Int8>:
            return evalTyped(expr: expression as! Polynomial<Int8>, x: x)
        default:
            fatalError("Unknown expresion type: \(type(of: expression))")
        }
    }
    
    static func == (lhs: ExpressionWrapper, rhs: ExpressionWrapper) -> Bool {
        lhs.expression.equals(rhs.expression)
    }
    
    func hash(into hasher: inout Hasher) {
        expression.hash(into: &hasher)
    }
}

extension ExpressionWrapper: CustomStringConvertible {
    var description: String { expression.description }
}

extension ExpressionWrapper: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    convenience init(integerLiteral value: IntegerLiteralType) {
        self.init(expression: Polynomial<IntegerLiteralType>(integerLiteral: value))
    }
}

extension ExpressionWrapper: AdditiveArithmetic {
    static func + (lhs: ExpressionWrapper<Number>, rhs: ExpressionWrapper<Number>) -> Self {
        ExpressionWrapper(expression: lhs.expression.adding(rhs.expression)) as! Self
    }
    
    func negated() -> Self {
        ExpressionWrapper(expression: expression.negated()) as! Self
    }
    
    static func - (lhs: ExpressionWrapper<Number>, rhs: ExpressionWrapper<Number>) -> Self {
        return ExpressionWrapper(expression: lhs.expression.adding(rhs.expression.negated())) as! Self
    }
    
    static var zero: ExpressionWrapper<Number> {
        ExpressionWrapper(expression: Polynomial<Number>.zero)
    }
}

//typealias Magnitude = ExpressionWrapper<Number>
