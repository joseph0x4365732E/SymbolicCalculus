//
//  UnaryOperation.swift
//  
//
//  Created by Joseph Cestone on 8/23/22.
//

import Foundation

public struct Abs {
    var arg1: any Expression
}

extension Abs: Hashable, CustomStringConvertible {
    public static func == (lhs: Abs, rhs: Abs) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "abs(" + arg1.description + ")"
    }
}

extension Abs: Boundable{
    public typealias N = AnyScalar
    public var min: N { AnyScalar(scalar: Swift.min(AnyScalar(scalar: N.zero), AnyScalar(scalar: arg1.min))) }
    public var max: N { AnyScalar(scalar: arg1.max) }
}

extension Abs: KnownSign, Absolutable {
    public var isNegative: Bool { false }
    public var abs: Abs { self }
}

    extension Abs: Simplifiable {
        public func simplified() -> any Expression {
            let arg1Sim = arg1.simplified()
            if arg1Sim is Absolutable {
                return (arg1Sim as! Absolutable).abs as! (any Expression)
            } else {
                return Abs(arg1: arg1Sim)
            }
        }
    }

extension Abs: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .abs, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        arg1.eval(x:x).abs as! N
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Abs else { return false }
        return (other as! Abs) == self
    }
    
    public func multiplied(by other: any Expression) -> any Expression {
        fatalError()
    }
}

//extension Abs: Reciprocable {
//    public var reciprocal: Abs { Abs(arg1: arg1.reciprocal) }
//}
