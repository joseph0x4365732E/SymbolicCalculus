//
//  Expression.swift
//  
//
//  Created by Joseph Cestone on 8/17/22.
//

import Foundation

public protocol Boundable {
    associatedtype N: Scalar
    var min: N { get }
    var max: N { get }
    var bounds: ClosedRange<N> { get }
    var isNegative: Bool? { get }
}

extension Boundable {
    public var bounds: ClosedRange<N> { min...max }
}

extension Boundable {
    public var isNegative: Bool? {
        if max < 0 { return true } // must be negative
        if min >= 0 { return false } // must be positive
        return nil
    }
}

public protocol Expression: Hashable, CustomStringConvertible, Boundable {
    var eType: ExpressionType { get }
    var resolved: Bool { get }
    func eval(x: AnyScalar) -> AnyScalar
}

extension Expression {
    //TODO: add substitution with known simplifications
}
