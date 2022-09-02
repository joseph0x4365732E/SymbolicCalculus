//
//  Negative.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Negative {
    var arg1: any Expression
}

extension Negative: Hashable, CustomStringConvertible {
    public static func == (lhs: Negative, rhs: Negative) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "-(" + arg1.description + ")"
    }
}

extension Negative: Boundable{
    public typealias N = AnyScalar
    public var min: N { -AnyScalar(arg1.min) }
    public var max: N { -AnyScalar(arg1.max) }
}

extension Negative: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .negative, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        -(arg1.eval(x:x) as! N)
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Negative else { return false }
        return (other as! Negative) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.negated()
    }
}
