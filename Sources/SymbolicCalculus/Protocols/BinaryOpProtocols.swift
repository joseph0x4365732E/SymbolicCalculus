//
//  BinaryOpProtocols.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation

// Normal Math
public protocol Addable {
    static func + (lhs: Self, rhs: Self) -> Self
}

public protocol Negatable: Addable {
    func negated() -> Self
}

extension Negatable {
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs + rhs.negated()
    }
    
    static prefix func - (rhs: Self) -> Self {
        return rhs.negated()
    }
}

public protocol Multipliable { // Not all Expressions
    static func * (lhs: Self, rhs: Self) -> Self
}

public protocol Divisible {
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self)
    func isMultiple(of: Self) -> Bool
    static func / (lhs: Self, rhs: Self) -> Self
    static func % (lhs: Self, rhs: Self) -> Self
}
