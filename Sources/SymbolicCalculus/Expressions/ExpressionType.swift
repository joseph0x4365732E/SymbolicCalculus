//
//  ExpressionType.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public enum ExpressionType: Hashable {
    public enum UnaryOperationType {
        case abs
        case negative
        case sqrt
        case ln
        case log2
        case log10
        case factorial
    }
    
    public enum BinaryOperationType {
        case sum
        case difference
        case product
        case quotient
        case exponential
        case logx
        case mod
        case nthDerivative
        case nthIntegral
    }
    
    case constant(sType: ScalarType)
    case polynomial(sType: ScalarType)
    case unaryOperation(uType: UnaryOperationType, sType: ScalarType)
    case binaryOperation(bType: BinaryOperationType, sType: ScalarType)
    
    var sType: ScalarType {
        switch self {
        case .constant(sType: let sType):                   return sType
        case .polynomial(sType: let sType):                 return sType
        case .unaryOperation(uType: _, sType: let sType):   return sType
        case .binaryOperation(bType: _, sType: let sType):  return sType
        }
    }
}

