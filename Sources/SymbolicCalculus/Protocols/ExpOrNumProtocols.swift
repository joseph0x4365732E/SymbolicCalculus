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
public protocol Rootable {
    func perfectRoot(root: Int) -> Self
    func root(root: Int) -> Self
}

public protocol Raisable: Boundable {
    func expressionRaisedToSelfPower(constant: N) -> Self
}
