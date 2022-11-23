//
//  ExpressionParser.swift
//  
//
//  Created by Joseph Cestone on 9/11/22.
//

import Foundation

public final class ExpressionParser {
    /// Determines if parsed constants are exact `Fraction` or finite precision
    /// `Double` types
    public var exactPrecision: Bool
    /// The type of `Scalar` to use for parsed constants, depending on if
    /// `exactPrecision` is enabled.
    var scalarType: ScalarType { exactPrecision ? .fraction : .double }
    
    public init(exact: Bool) {
        self.exactPrecision = exact
    }
    
    /// Parse string to constant of correct `scalarType`.
    private func makeConstant(_ str: String) -> any Expression {
        switch scalarType {
        case .fraction: return Constant(Fraction(str)!)
        case .double: return Constant(Double(str)!)
        case .float: return Constant(Float(str)!)
        case .float16: fatalError("Not programmed for Float16")
        default:
            fatalError("Unexpected ScalarType: \(scalarType)")
        }
    }
    
    /// Constructs Expression of given `ExpressionType`.
    private func makeExpression(eType: ExpressionType) throws -> any Expression {
        switch eType {
        case .container(let contents):
            return try parseLevel(input: contents)
        case .unaryOperation(uType: let uType, sType: _):
            switch uType {
            case .abs:          return Abs()
            case .negative:     return Negative()
            case .sqrt:         return Sqrt()
            case .ln:           return Ln()
            case .log2:         return Log2()
            case .log10:        return Log10()
            case .factorial:    return Factorial()
            }
        case .binaryOperation(bType: let bType, sType: _):
            switch bType {
            case .sum:              return Sum()
            case .difference:       return Difference()
            case .product:          return Product()
            case .quotient:         return Quotient()
            case .exponential:      return Exponential()
            case .logx:             return Logx()
            case .mod:              return Mod()
            case .nthDerivative:    return NthDerivative()
            case .nthIntegral:      return NthIntegral()
            }
        default:
            fatalError("Cannot create expression of type \(eType)")
        }
    }
    
    private func formStack(from input: String) throws -> [any Expression] {
        var remaining = input
        var levelStack: [any Expression] = []
        
        while !remaining.isEmpty {
            let stringExpression = remaining.dropLeadingKeyword()
            switch stringExpression {
            case .space: continue
            case .expression(let eType):
                levelStack.append(try makeExpression(eType: eType))
            case .constant(let string):
                levelStack.append(makeConstant(string))
            case nil:
                throw ParseError.unexpectedInput(remaining: remaining)
            }
        }
        
        return levelStack
    }
    
    private func resolve(index: inout Int, in stack: inout [any Expression]) throws {
        var expression: any Expression {
            get { stack[index] }
            set { stack[index] = newValue }
        }
        
        func requireArg(atOffset offset: Int) -> any Expression {
            guard offset != 0 else { fatalError("Cannot use self (own index) as argument for resolving expression.") }
            let range = stack.indices
            let argIndex = index + offset
            guard range.contains(argIndex) else { fatalError("Stack does not contain required argument at offset \(offset) from \(expression.eType.position) expression at index \(index).") }
            if offset < 0 { index -= 1 }
            return stack.remove(at: argIndex)
        }
        
        switch expression.eType {
        case .empty: fatalError("Found empty expression at index \(index) in stack: \(stack).")
        case .container(let contents):
            expression = try parseLevel(input: contents)
            return
        case .constant(_): break
        case .variable(_): break
        case .polynomial(_): break
        case .unaryOperation(_, _):
            var unaryOp = expression as! any UnaryOperation
            unaryOp.arg1 = requireArg(atOffset: expression.eType.position.arg1Index)
            expression = unaryOp
        case .binaryOperation(let bType, _):
            var unaryOp = expression as! any BinaryOperation
            unaryOp.arg2 = requireArg(atOffset: bType.position.arg2Index)
            unaryOp.arg1 = requireArg(atOffset: bType.position.arg1Index)
            expression = unaryOp
        }
    }
    
    private func addNegatives(in stack: inout [any Expression]) {
        var canAddPrevious = false
        for index in stack.indices {
            let currentExpression = stack[index]
            switch currentExpression.eType {
            case .binaryOperation(bType: .difference, sType: _):
                if !canAddPrevious && !stack[index].resolved {
                    stack[index] = Negative()
                }
            case .constant(_), .variable(_): canAddPrevious = true
            default:
                // update canAddLast for when currentExpression is the previous
                canAddPrevious = currentExpression.eType.position == .postfix || currentExpression.resolved
            }
        }
    }
    
    private func assemble(stack: [any Expression]) throws -> any Expression {
        var stack = stack
        addNegatives(in: &stack)
        
        if stack.count == 1 { return stack.first! }
        
        for currentPrecendence in ExpressionPrecendence.decendingPrecedence {
            var idx = 0
            while idx < stack.count {
                if stack[idx].eType.precedence == currentPrecendence && !stack[idx].resolved {
                    // resolve the expression
                    try resolve(index: &idx, in: &stack)
                }
                idx += 1
            }
            if stack.count == 1 { return stack.first! }
        }
        guard stack.count == 1 else {
            fatalError("Too many expressions remain on the stack: \(stack).")
        }
        return stack.first!
    }
    
    private func parseLevel(input: String) throws -> any Expression {
        let stack = try formStack(from: input)
        return try assemble(stack: stack)
    }
    
    public func parse(input: String) throws -> any Expression {
        let res = try parseLevel(input: input.lowercased())
        return res
    }
}
