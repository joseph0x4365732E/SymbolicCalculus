//
//  ExpressionString.swift
//  
//
//  Created by Joseph Cestone on 9/9/22.
//

import Foundation

/// Enumeration of all possible keywords that fall into
public enum ExpressionKeyword: Equatable {
    case space
    case expression(eType: ExpressionType)
    case constant(string: String)
    
    public var string: String {
        switch self {
        case .space: return " "
        case .expression(eType: let eType): return eType.string
        case .constant(let string): return string
        }
    }
    
    public var precendence: ExpressionPrecendence {
        switch self {
        case .expression(eType: let eType): return eType.precedence
        case .constant(_):         return .container
        default: fatalError("ExpressionString type \(self) has no precedence.")
        }
    }
    
    public static var allKeywords: [ExpressionKeyword] =
    [ExpressionKeyword.space] +
    ExpressionType.allKeywords.map { ExpressionKeyword.expression(eType: $0) }
}

/// The numerical priority with which an `Expression` is given its arguments in the stack.
public enum ExpressionPrecendence: Int, CaseIterable {
    case container = 70
    case prefix = 60
    case postfix = 50
    case infix = 40
    case exponent = 30
    case multiplication = 20
    case addition = 10
    case none = 0
    
    public static let decendingPrecedence: [ExpressionPrecendence] = [.container, .prefix, .postfix, .infix, .exponent, .multiplication, .addition]
}
