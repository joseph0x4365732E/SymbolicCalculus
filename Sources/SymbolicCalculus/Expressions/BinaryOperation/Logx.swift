//
//  Logx.swift
//  
//
//  Created by Joseph Cestone on 8/30/22.
//

import Foundation

public struct Logx: BinaryOperation {
    /// Base - x
    public var arg1: any Expression
    public var arg2: any Expression
    
    public init(arg1: any Expression, arg2: any Expression) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

extension Logx: Hashable, CustomStringConvertible {
    public static func == (lhs: Logx, rhs: Logx) -> Bool {
        return lhs.arg1.equals(rhs.arg1) &&
        lhs.arg2.equals(rhs.arg2)
    }
    
    public func hash(into hasher: inout Hasher) {
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String { "Log(x: " + arg1.description + ", " + arg2.description + ")" }
}

extension Logx: Boundable {
    public typealias N = AnyScalar
    public var min: N {
        let a1Ma = arg1.max.double
        let a1Mi = arg1.min.double
        let a2Ma = arg2.max.double
        let a2Mi = arg2.min.double
        
        // divide by the base, arg1 is base
        let minOverMax = Darwin.log2(a1Mi) / Darwin.log2(a2Ma)
        let minOverMin = Darwin.log2(a1Mi) / Darwin.log2(a2Mi)
        let maxOverMax = Darwin.log2(a1Ma) / Darwin.log2(a2Ma)
        let maxOverMin = Darwin.log2(a1Ma) / Darwin.log2(a2Mi)
        return AnyScalar(Swift.min(minOverMax, minOverMin, maxOverMax, maxOverMin))
    }
    public var max: N {
        let a1Ma = arg1.max.double
        let a1Mi = arg1.min.double
        let a2Ma = arg2.max.double
        let a2Mi = arg2.min.double
        
        // divide by the base, arg1 is base
        let minOverMax = Darwin.log2(a2Mi) / Darwin.log2(a2Ma)
        let minOverMin = Darwin.log2(a1Mi) / Darwin.log2(a2Mi)
        let maxOverMax = Darwin.log2(a1Ma) / Darwin.log2(a2Ma)
        let maxOverMin = Darwin.log2(a1Ma) / Darwin.log2(a2Mi)
        return AnyScalar(Swift.max(minOverMax, minOverMin, maxOverMax, maxOverMin))
    }
}

extension Logx: Expression {
    public var eType: ExpressionType {
        .binaryOperation(
            bType: .logx,
            sType: ScalarType(combining: arg1.eType.sType, arg2.eType.sType)
        )
    }
    public func eval(x: any Scalar) -> any Scalar { arg1.eval(x: x).logx(x: arg2.eval(x: x)) }
    
    public func simplified() -> any Expression {
        arg1.logx(x: arg2)
    }
//    func negated() -> any Expression { arg1.negated().plus(arg2.negated()) }
//
//    func multiplied(by other: any Expression) -> any Expression {
//        Logx(arg1: arg1.multiplied(by: other), arg2: arg2.multiplied(by: other))
//    }
    
    
}
