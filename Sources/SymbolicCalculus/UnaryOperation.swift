//
//  UnaryOperation.swift
//  
//
//  Created by Joseph Cestone on 8/23/22.
//

import Foundation

public struct UnaryOperation<E: Expression> {
    
    enum Operator: UInt8, CustomStringConvertible {
        case abs = 1
        case sqrt = 2
        case log = 3
        case ln = 4
        case derivative = 5
        
        var description: String {
            switch self {
            case .abs: return "abs"
            case .sqrt: return "sqrt"
            case .log: return "log"
            case .ln: return "ln"
            case .derivative: return "derivative"
            }
        }
    }
    
    var argument: E
    var opType: Operator
}

extension UnaryOperation: Hashable, Comparable {
    public static func < (lhs: UnaryOperation<E>, rhs: UnaryOperation<E>) -> Bool {
        lhs.opType.rawValue < rhs.opType.rawValue
    }
}

extension UnaryOperation: CustomStringConvertible {
    public var description: String {
        opType.description + "(" + argument.description + ")"
    }
}


