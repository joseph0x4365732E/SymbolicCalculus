import Foundation
/*
public final class Function<Number: Scalar> {
    //SignedNumeric, Hashable, Comparable
    var expressionWrappers: [ExpressionWrapper<Number>]
    
    init(_ expressions: [ExpressionWrapper<Number>]) {
        self.expressionWrappers = expressions
    }
    
    init(_ expressions: [any Expression]) {
        self.expressionWrappers = expressions.map { expression in
            ExpressionWrapper(expression: expression)
        }
    }
    
    convenience init(_ expressions: any Expression...) {
        self.init(expressions)
    }
    
    func reduceExpressions() {
        let expressionsTypeTuples = expressionWrappers.map { wrapper in
            ("\(type(of: wrapper.expression))", wrapper)
        }
        let expressionsByType = Dictionary(expressionsTypeTuples) { lhs, rhs in
            lhs + rhs
        }
        expressionWrappers = Array(expressionsByType.values)
    }
    
    func f(x: Number) -> Number {
        expressionWrappers.map { expWrapper in
            expWrapper.eval(x: x)
        }.sum
    }
    
    func equalTo(_ other: Function<Number>) -> Bool {
        expressionWrappers == other.expressionWrappers
    }
    
    func lessThan(_ other: Function<Number>) -> Bool {
        #warning("bad code")
        return false//expression.lessThan(other.expression)
    }
}

extension Function: Hashable, Comparable {
    public static func == (lhs: Function<Number>, rhs: Function<Number>) -> Bool {
        lhs.equalTo(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        fatalError("Must override Function.hash(into)")
    }
    
    public static func < (lhs: Function<Number>, rhs: Function<Number>) -> Bool {
        lhs.lessThan(rhs)
    }
}

extension Function: CustomStringConvertible {
    public var description: String {
        fatalError()
    }
}

extension Function: AdditiveArithmetic {
    public static func + (lhs: Function<Number>, rhs: Function<Number>) -> Self {
        let sum = Function(lhs.expressionWrappers + rhs.expressionWrappers)
        sum.reduceExpressions()
        return sum as! Self
    }
    
    func negated() -> Self {
        let wrappers = expressionWrappers.map { wrapper in
            wrapper.negated()
        }
        return Function(wrappers) as! Self
    }
    
    public static func - (lhs: Function<Number>, rhs: Function<Number>) -> Self {
        (lhs + rhs.negated()) as! Self
    }
    
    public static var zero: Self {
        fatalError()
    }
}
*/
