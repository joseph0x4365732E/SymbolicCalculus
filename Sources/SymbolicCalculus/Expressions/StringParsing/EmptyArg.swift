//
//  EmptyArg.swift
//  
//
//  Created by Joseph Cestone on 9/8/22.
//

import Foundation

public struct EmptyArg: Identifiable {
    public var id = UUID()
    
    public init(id: UUID = UUID()) {
        self.id = id
    }
}


// MARK: CustomStringConvertible
extension EmptyArg: Hashable, CustomStringConvertible {
    public var description: String { "empty" }
}

extension EmptyArg: Boundable {
    public typealias C = AnyScalar
    public typealias N = C
    
    public var min: C { .min }
    public var max: C { .max }
}

extension EmptyArg: Expression {
    public var resolved: Bool { false }
    
    public func eval(x: C) -> C {
        fatalError("Cannot evaluate empty argument expression.")
    }
    public var eType: ExpressionType { .empty }
    
    public func equals(_ other: any Expression) -> Bool { false }
}
