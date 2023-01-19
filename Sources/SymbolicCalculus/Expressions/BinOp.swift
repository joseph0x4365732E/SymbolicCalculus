//
//  BinOp.swift
//  
//
//  Created by Joseph Cestone on 11/23/22.
//

import Foundation

public struct BinOp<S: Scalar> {
    public var type: ExpressionType.BinaryOpType
    public var sType: ScalarType
    public var arg1: AnyExpression<S>
    public var arg2: AnyExpression<S>
    private var scalarOp: (S, S) -> (S) {
        switch type {
        case .sum:          return { $0 + $1 }
        case .difference:   return { $0 - $1 }
        case .product:      return { $0 * $1 }
        case .quotient:     return { $0 / $1 }
        case .exponential:  return { $0.power($1) }
            
        case .logx:         return { $1.logx(x: $0) }
            
        case .mod:          return { $0.mod($1) }
            
        case .nthDerivative:return { $0.nthDerivative($1) }
            
        case .nthIntegral:  fatalError("This is not a constant.")
            
        }
    }
    
    public init(_ type: ExpressionType.BinaryOpType, sType: ScalarType, arg1: AnyExpression<S>, arg2: AnyExpression<S>) {
        self.type = type
        self.sType = sType
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

extension BinOp: Boundable {
    public typealias N = S
    private var possibleExtremes: [S] {
        let a1Ma = arg1.max
        let a1Mi = arg1.min
        let a2Ma = arg2.max
        let a2Mi = arg2.min
        
        let minAndMin = scalarOp(a1Mi, a2Mi)
        let minAndMax = scalarOp(a1Mi, a2Ma)
        let maxAndMin = scalarOp(a1Ma, a2Mi)
        let maxAndMax = scalarOp(a1Ma, a2Ma)
        return [minAndMax, minAndMin, maxAndMax, maxAndMin]
    }
    #warning("this does not work for expressions like sine and cosine")
    public var min: S { return possibleExtremes.min()! }
    public var max: S { return possibleExtremes.max()! }
}

extension BinOp: Hashable, CustomStringConvertible {
    public static func == (lhs: BinOp, rhs: BinOp) -> Bool {
        lhs.type == rhs.type &&
        lhs.arg1 == rhs.arg1 &&
        lhs.arg2 == rhs.arg2
    }
    
    public func hash(into hasher: inout Hasher) {
        type.hash(into: &hasher)
        arg1.hash(into: &hasher)
        arg2.hash(into: &hasher)
    }
    
    public var description: String {
        type.stringConversion(arg1: arg1, arg2: arg2)
    }
}

extension BinOp: Expression {
    public var eType: ExpressionType { .binaryOperation(bType: type, sType: sType, arg1Type: arg1.eType, arg2Type: arg2.eType) }
    public var resolved: Bool { arg1.resolved && arg2.resolved }

    public func eval(x: AnyScalar) -> AnyScalar {
        AnyScalar(scalarOp(S(arg1.eval(x: x)), S(arg2.eval(x: x))))
    }
}

extension BinOp {
    public static func sum<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.sum, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func difference<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.difference, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func product<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.product, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func quotient<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.quotient, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func mod<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.mod, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func exponential<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.exponential, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func logx<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.logx, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func nthDerivative<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.nthDerivative, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
    
    public static func nthIntegral<S: Scalar>(arg1: AnyExpression<S>, arg2: AnyExpression<S>) -> BinOp<S> {
        BinOp<S>(.nthIntegral, sType: S.staticType, arg1: arg1, arg2: arg2)
    }
}
