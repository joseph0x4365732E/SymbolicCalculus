//
//  ExpressionType.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

/// Enumeration of types conforming to `Expression`.
/// Cases:
///    - `empty`
///    - `container(string)`
///    - `variable(name: String)`
///    - `constant(ScalarType)`
///    - `polynomial(ScalarType)` - info might be old
///    - `unaryOperation(UnaryOpType`
///   -
public indirect enum ExpressionType: Hashable { /// indirect means stored so memory size can grow - to allow recursive storage
    
    /// Position of operator of an `ExpressionType`.
    public enum OperatorPosition {
        case prefix
        case infix
        case postfix
        
        public var arg1Index: Int {
            switch self {
            case .prefix:   return 1
            case .infix:    return -1
            case .postfix:  return -1
            }
        }
        
        public var arg2Index: Int {
            switch self {
            case .prefix:   return 2
            case .infix:    return 1
            case .postfix:  fatalError("No postfix operations should have multiple arguments.")
            }
        }
    }
    
    // MARK: UnaryOpType
    /// UnaryOperationTypes that are `ExpressionTypes`.
    public enum UnaryOpType {
        case abs
        case negative
        case sqrt
        case ln
        case log2
        case log10
        case factorial
        
        public var string: String {
            switch self {
            case .abs:          return "abs"
            case .negative:     return ""
            case .sqrt:         return "sqrt"
            case .ln:           return "ln"
            case .log2:         return "log2"
            case .log10:        return "log10"
            case .factorial:    return "!"
            }
        }
        
        public var position: OperatorPosition {
            switch self {
            case .factorial:    return .postfix
            default:            return .prefix
            }
        }
        
        public var precedence: ExpressionPrecendence {
            switch self {
            case .negative:     return .multiplication
            case .factorial:    return .postfix
            default:            return .prefix
            }
        }
        
        public func stringConversion(arg1: any Expression) -> String {
            let a1 = arg1.description
            switch position {
            case .prefix:   return string + "(" + a1 + ")"
            case .infix:    fatalError("There are no infix Unary operators")
            case .postfix:  return "(" + a1 + ")" + string
            }
        }
        
        public static var allKeywords: [UnaryOpType] = [
            .abs,
            .sqrt,
            .ln,
            .log2,
            .log10,
            .factorial
        ]
    }
    
    // MARK: BinaryOpType
    /// BinaryOperationTypes that are `ExpressionTypes`.
    public enum BinaryOpType: CaseIterable {
        case sum
        case difference
        case product
        case quotient
        case exponential
        case logx
        case mod
        case nthDerivative
        case nthIntegral
        
        public var string: String {
            switch self {
            case .sum:              return "+"
            case .difference:       return "-"
            case .product:          return "*"
            case .quotient:         return "/"
            case .exponential:      return "^"
            case .logx:             return "logx"
            case .mod:              return "mod"
            case .nthDerivative:    return "nthderivative"
            case .nthIntegral:      return "nthintegral"
            }
        }
        
        public var position: OperatorPosition {
            switch self {
            case .logx:             return .prefix
            case .mod:              return .infix
            case .nthDerivative:    return .prefix
            case .nthIntegral:      return .prefix
            default:                return .infix
            }
        }
        
        public var precedence: ExpressionPrecendence {
            switch self {
            case .sum:              return .addition
            case .difference:       return .addition
            case .product:          return .multiplication
            case .quotient:         return .multiplication
            case .exponential:      return .exponent
            case .logx:             return .exponent
            case .mod:              return .infix
            case .nthDerivative:    return .prefix
            case .nthIntegral:      return .prefix
            }
        }
        
        public func stringConversion(arg1: any Expression, arg2: any Expression) -> String {
            let a1 = arg1.description
            let a2 = arg2.description
            switch position {
            case .prefix:   return string + "(" + a1 + ", " + a2 + ")"
            case .infix:    return a1 + string + a2
            case .postfix:  fatalError("There are no postfix Binary operators")
            }
        }
        
        public static var allKeywords: [BinaryOpType] = allCases
    }
    
    // MARK: ExpressionType cases
    case empty
    case container(contents: String)
    case constant(sType: ScalarType)
    case variable(name: String)
    case polynomial(sType: ScalarType)
    case unaryOperation(uType: UnaryOpType, sType: ScalarType, arg1Type: ExpressionType)
    case binaryOperation(bType: BinaryOpType, sType: ScalarType, arg1Type: ExpressionType, arg2Type: ExpressionType)
    
    public var sType: ScalarType {
        switch self {
        case .empty:                                        return .any
        case .container:                                    return .any
        case .variable(_):                                  return .any
        case .constant(sType: let sType):                   return sType
        case .polynomial(sType: let sType):                 return sType
        case .unaryOperation(uType: _, sType: let sType, _):   return sType
        case .binaryOperation(bType: _, sType: let sType, _, _):  return sType
        }
    }
    
    public var numberOfArguments: Int {
        switch self {
        case .empty:                                return 0
        case .container:                            return 0
        case .variable(_):                          return 0
        case .constant(sType: _):                   return 0
        case .polynomial(sType: _):                 return 0
        case .unaryOperation(uType: _, sType: _, _):   return 1
        case .binaryOperation(bType: _, sType: _, _, _):  return 2
        }
    }
    
    public var string: String {
        switch self {
        case .empty: return ""
        case .container(let contents): return contents
        case .unaryOperation(let uType, _, _): return uType.string
        case .binaryOperation(let bType, _, _, _): return bType.string
        default: fatalError("ExpressionType \(self) does not have a string.")
        }
    }
    
    public var position: OperatorPosition {
        switch self {
        case .unaryOperation(let uType, _, _): return uType.position
        case .binaryOperation(let bType, _, _, _): return bType.position
        default: fatalError("ExpressionType \(self) does not have an operator position.")
        }
    }
    
    public var precedence: ExpressionPrecendence {
        switch self {
        case .container(_):                     return .container
        case .constant(_):                      return .none
        case .unaryOperation(let uType, _, _):     return uType.precedence
        case .binaryOperation(let bType, _, _, _):    return bType.precedence
        default: fatalError("ExpressionType \(self) has no precedence")
        }
    }
    
    public var simplifiesToConstant: Bool {
        switch self {
        case .empty:            return false
        case .container(_):     return false
        case .constant(_):      return true
        case .variable(_):      return false
        case .polynomial(_):    return false
        case .unaryOperation(_, _, arg1Type: let arg1Type):
            return arg1Type.simplifiesToConstant
        case .binaryOperation(_, _, arg1Type: let arg1Type, arg2Type: let arg2Type):
            return arg1Type.simplifiesToConstant && arg2Type.simplifiesToConstant
        }
    }
    
    public static var allKeywords: [ExpressionType] =
    UnaryOpType.allKeywords.map {
        ExpressionType.unaryOperation(uType: $0, sType: .any, arg1Type: .empty)
    } +
    BinaryOpType.allKeywords.map {
        ExpressionType.binaryOperation(bType: $0, sType: .any, arg1Type: .empty, arg2Type: .empty)
    }
}

