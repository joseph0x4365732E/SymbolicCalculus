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
    }
    
    case polynomial(sType: ScalarType)
    case unaryOperation(uType: UnaryOperationType, sType: ScalarType)
    
    var sType: ScalarType {
        switch self {
        case .polynomial(sType: let sType):                 return sType
        case .unaryOperation(uType: _, sType: let sType):   return sType
        }
    }
}

