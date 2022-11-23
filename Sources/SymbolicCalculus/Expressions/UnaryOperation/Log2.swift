//
//  Log2.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Log2: UnaryOperation {
    public var arg1: any Expression
    
    public init(arg1: any Expression) {
        self.arg1 = arg1
    }
}

extension Log2: Hashable, CustomStringConvertible {
    public static func == (lhs: Log2, rhs: Log2) -> Bool {
        lhs.arg1.equals(rhs.arg1)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
    }
    
    public var description: String {
        "Log2(" + arg1.description + ")"
    }
}

extension Log2: Boundable{
    public typealias N = AnyScalar
    public var min: N { AnyScalar(arg1.min.log2) }
    public var max: N { AnyScalar(arg1.max.log2) }
}

extension Log2: Expression {
    public var eType: ExpressionType { .unaryOperation(uType: .log2, sType: N.staticType ) }
    
    public func eval(x: N) -> N {
        arg1.eval(x:x).ln as! N
    }
    
    public func eval(x: any Scalar) -> any Scalar {
        fatalError()
    }
    
    public func equals(_ other: any Expression) -> Bool {
        guard other is Log2 else { return false }
        return (other as! Log2) == self
    }
        
    public func simplified() -> any Expression {
        let arg1Sim = arg1.simplified()
        return arg1Sim.log2
    }
}
