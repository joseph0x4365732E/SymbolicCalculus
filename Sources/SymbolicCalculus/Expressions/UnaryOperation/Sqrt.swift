//
//  Sqrt.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Sqrt {
    var arg1: any Expression
}

extension Sqrt: Hashable, CustomStringConvertible {
    public static func == (lhs: Sqrt, rhs: Sqrt) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "Sqrt(" + arg1.description + ")"
    }
}

extension Sqrt: Boundable{
    public typealias N = AnyScalar
    public var min: N {
        let arg1Mi = AnyScalar(arg1.min)
        return arg1Mi.isNegative ? AnyScalar.zero : arg1Mi.sqrt
    }
    public var max: N {
        let arg1Ma = AnyScalar(arg1.max)
        return arg1Ma.isNegative ? AnyScalar.zero : arg1Ma.sqrt
        
    }
}

extension Sqrt: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .sqrt, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        (arg1.eval(x:x) as! N).sqrt
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Sqrt else { return false }
        return (other as! Sqrt) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.sqrt
    }
}
