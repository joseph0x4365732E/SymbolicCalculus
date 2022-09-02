//
//  Factorial.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Factorial {
    var arg1: any Expression
}

extension Factorial: Hashable, CustomStringConvertible {
    public static func == (lhs: Factorial, rhs: Factorial) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "(" + arg1.description + ")!"
    }
}

extension Factorial: Boundable{
    public typealias N = AnyScalar
    public var min: N { AnyScalar(1) }
    public var max: N { .max }
}

extension Factorial: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .factorial, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        arg1.eval(x:x).factorial as! N
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Factorial else { return false }
        return (other as! Factorial) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.factorial
    }
    public var abs: any Expression { arg1.abs }
}
