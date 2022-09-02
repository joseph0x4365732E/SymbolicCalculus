//
//  Product.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

struct Product {
    var arg1: any Expression
    var arg2: any Expression
}

extension Product: Hashable, CustomStringConvertible {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    var description: String { arg1.description + " * " + arg2.description }
}

extension Product: Boundable {
    public typealias N = AnyScalar
    public var min: N {
        AnyScalar(arg1.min) *
        AnyScalar(arg2.min)
    }
    public var max: N {
        AnyScalar(arg1.max) *
        AnyScalar(arg2.max)
    }
}

extension Product: Expression {
    var eType: ExpressionType { .binaryOperation(bType: .product, sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)) }
    func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).multiplied(by: arg2.eval(x: x)) }
    
    func simplified() -> any Expression {
        arg1.multiplied(by: arg2)
    }
    var abs: any Expression {
        let arg1Sim = arg1.simplified()
        let arg2Sim = arg2.simplified()
        
        guard let arg1N = arg1Sim.isNegative,
              let arg2N = arg2Sim.isNegative else {
            return Abs(arg1: Product(arg1: arg1Sim, arg2: arg2Sim))
        }
        if arg1N == arg2N {
            return Product(arg1: arg1Sim, arg2: arg2Sim)
        }
        
        if arg1N { // 1 is negative
            return Product(arg1: arg1Sim.abs, arg2: arg2Sim)
        } else { // 2 is negative
            return Product(arg1: arg1Sim, arg2: arg2Sim.abs)
        }
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Product(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
