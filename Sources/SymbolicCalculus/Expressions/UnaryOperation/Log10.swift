//
//  Log10.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Log10 {
    var arg1: any Expression
}

extension Log10: Hashable, CustomStringConvertible {
    public static func == (lhs: Log10, rhs: Log10) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "Log10(" + arg1.description + ")"
    }
}

extension Log10: Boundable{
    public typealias N = AnyScalar
    public var min: N { AnyScalar(arg1.min.log10) }
    public var max: N { AnyScalar(arg1.max.log10) }
}

extension Log10: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .log10, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        arg1.eval(x:x).ln as! N
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Log10 else { return false }
        return (other as! Log10) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.log10
    }
}
