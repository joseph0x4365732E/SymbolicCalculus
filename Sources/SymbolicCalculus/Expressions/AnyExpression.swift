//
//  AnyExpression.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public struct AnyExpression<S: Scalar>  {
    public var exp1: any Expression
    public var eType: ExpressionType { exp1.eType }
    public var resolved: Bool { exp1.resolved }
    
    public init(_ exp1: any Expression) {
        self.exp1 = exp1
    }
    
    static func withTypedCombine<ReturnType>(
        lhs: AnyExpression,
        rhs: AnyExpression,
        
        ifDiffTypes: () -> (ReturnType),
        ifConst: (Constant<S>, Constant<S>) -> (ReturnType),
        ifSameVar: (Variable<S>, Variable<S>) -> (ReturnType),
        ifUnOp: (UnaryOp<S>, UnaryOp<S>) -> (ReturnType),
        ifBinOp: (BinOp<S>, BinOp<S>) -> (ReturnType),
        ifAnyExpression: (AnyExpression<S>, AnyExpression<S>) -> (ReturnType)
    ) -> ReturnType {
        guard lhs.eType == rhs.eType else { return ifDiffTypes() }
        let type = lhs.eType
        switch type {
        case .empty: return ifDiffTypes()
        case .container(contents: _):
            return ifDiffTypes()
        case .constant(sType: _):
            return ifConst(lhs.exp1 as! Constant<S>, rhs.exp1 as! Constant<S>)
        case .variable(name: let lhsName):
            switch rhs.eType {
            case .variable(name: let rhsName):
                if lhsName == rhsName {
                    return ifSameVar(lhs.exp1 as! Variable<S>, rhs.exp1 as! Variable<S>)
                } else {
                    return ifDiffTypes()
                }
            default: fatalError("Contradiction: lhs and rhs for AnyExpression withTypedCombine have different ExpressionType's. They were already checked to have the same.")
            }
        case .polynomial(sType: _):
            fatalError("Polynomial needs to be fixed or deleted.")
        case .unaryOperation(_, _, _):
            return ifUnOp(lhs.exp1 as! UnaryOp, rhs.exp1 as! UnaryOp)
        case .binaryOperation(_, _, _, _):
            return ifBinOp(lhs.exp1 as! BinOp, rhs.exp1 as! BinOp)
        }
    }
}

extension AnyExpression: Boundable {
    public typealias N = S
    public var min: N { N(exp1.min) }
    public var max: N { N(exp1.max) }
}

extension AnyExpression: Hashable {
    public static func == (lhs: AnyExpression, rhs: AnyExpression) -> Bool {
        withTypedCombine(
            lhs: lhs,
            rhs: rhs,
            ifDiffTypes: { return false },
            ifConst: { $0 == $1 },
            ifSameVar: { $0 == $1 },
            ifUnOp: { $0 == $1 },
            ifBinOp: { $0 == $1 },
            ifAnyExpression: { $0 == $1 }
        )
    }
    
    public func hash(into hasher: inout Hasher) {
        exp1.hash(into: &hasher)
    }
}

extension AnyExpression: CustomStringConvertible {
    public var description: String { exp1.description }
}

extension AnyExpression: Expression {
    public func eval(x: AnyScalar) -> AnyScalar {
        exp1.eval(x: x)
    }
    
    public func simplified() -> AnyExpression {
        switch eType {
        case .empty: fatalError("Cannot simplify EmptyArgument.")
        case .container(contents: let contents):
            fatalError("Unevaluated Container: AnyExpression.simplified() cannot simplify Container. contents: \(contents)")
        case .constant(sType: _):           return self
        case .variable(name: _):            return self
        case .polynomial(sType: _):         return self
        case .unaryOperation(_, _, _):      return Simplifier.simplify(self)
        case .binaryOperation(_, _, _, _):  return Simplifier.simplify(self)
        }
    }
}
