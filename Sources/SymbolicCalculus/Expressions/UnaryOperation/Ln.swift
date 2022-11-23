//
//  Ln.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Ln: UnaryOperation {
    public var arg1: any Expression
    
    public init(arg1: any Expression) {
        self.arg1 = arg1
    }
}

extension Ln: Hashable, CustomStringConvertible {
    public static func == (lhs: Ln, rhs: Ln) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "Ln(" + arg1.description + ")"
    }
}

extension Ln: Boundable{
    public typealias N = AnyScalar
    public var min: N { AnyScalar(arg1.min.ln) }
    public var max: N { AnyScalar(arg1.max.ln) }
}

extension Ln: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .ln, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        arg1.eval(x:x).ln as! N
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Ln else { return false }
        return (other as! Ln) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.ln
    }
}
