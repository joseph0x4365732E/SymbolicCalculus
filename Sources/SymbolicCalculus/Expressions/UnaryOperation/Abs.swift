//
//  Abs.swift
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
    public var min: N { AnyScalar(Swift.min(AnyScalar(N.zero), AnyScalar(arg1.min))) }
    public var max: N { AnyScalar(arg1.max) }
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
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.abs
    }
    public var abs: any Expression { arg1.abs }
}

//extension Abs: Reciprocable {
//    public var reciprocal: Abs { Abs(arg1: arg1.reciprocal) }
//}
