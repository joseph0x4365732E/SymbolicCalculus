//
//  File.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation

public protocol Zeroable { // All expressions? Not always useful
    static var zero: Self { get }
}

// UnaryOperators
public protocol Absolutable { // Not all Expressions
    var abs: Self { get }
}

public protocol KnownSign: Absolutable { // Not all Expressions
    var isNegative: Bool { get }
}

public protocol Reciprocable {
    var reciprocal: Self { get }
}

public protocol IntegerPowerable {
    func power(exponent: Int) -> Self
}

public protocol Rootable {
    func perfectRoot(root: Int) -> Self
    func root(root: Int) -> Self
}

public protocol Raisable: Boundable {
    func expressionRaisedToSelfPower(constant: N) -> Self
}
