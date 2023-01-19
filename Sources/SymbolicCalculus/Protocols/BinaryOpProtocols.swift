//
//  BinaryOpProtocols.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation

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
