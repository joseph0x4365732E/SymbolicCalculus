//
//  Container.swift
//  
//
//  Created by Joseph Cestone on 9/8/22.
//

import Foundation

public struct Container {
    public var contents: String
    
    public init(_ contents: String) {
        self.contents = contents
    }
}

// MARK: CustomStringConvertible
extension Container: Hashable, CustomStringConvertible {
    public var description: String { "'\(contents)'" }
}

extension Container: Boundable {
    public typealias C = AnyScalar
    public typealias N = C
    
    public var min: C { .min }
    public var max: C { .max }
}

extension Container: Expression {
    public func eval(x: C) -> C {
        fatalError("Cannot evaluate container argument expression.")
    }
    public var eType: ExpressionType { .container(contents: contents) }
    public var resolved: Bool { true }
}
