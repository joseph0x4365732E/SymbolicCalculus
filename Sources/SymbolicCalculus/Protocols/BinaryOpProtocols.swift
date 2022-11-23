//
//  BinaryOpProtocols.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation

public protocol BinaryOperation: Expression {
    var arg1: any Expression { get set }
    var arg2: any Expression { get set }
    
    init(arg1: any Expression, arg2: any Expression)
    var resolved: Bool { get }
}

extension BinaryOperation {
    public init() { self.init(arg1: EmptyArg(), arg2: EmptyArg()) }
    public var resolved: Bool { !(arg1 is EmptyArg || arg2 is EmptyArg) }
}

public protocol UnaryOperation: Expression {
    var arg1: any Expression { get set }
    
    init(arg1: any Expression)
    var resolved: Bool { get }
}

extension UnaryOperation {
    public init() { self.init(arg1: EmptyArg()) }
    public var resolved: Bool { !(arg1 is EmptyArg) }
}

// Normal Math
public protocol Addable {
    func plus(_ other: Self) -> Self
}

public protocol Negatable: Addable {
    func negated() -> Self
}

extension Negatable {
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs.plus(rhs.negated())
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

extension Divisible {
    public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        (self % rhs, self / rhs)
    }
}
