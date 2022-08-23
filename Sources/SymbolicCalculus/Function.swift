import Foundation

public final class Function<Number: Finite> {
    //SignedNumeric, Hashable, Comparable
    var expressions: [ExpressionWrapper<Number>]
    
    init(_ expressions: [ExpressionWrapper<Number>]) {
        self.expressions = expressions
    }
    
    init(_ expressions: [any Expression]) {
        self.expressions = expressions.map { expression in
            ExpressionWrapper(expression: expression)
        }
    }
    
    convenience init(_ expressions: any Expression...) {
        self.init(expressions)
    }
    
    func reduceExpressions() {
        let expressionsTypeTuples = expressions.map { wrapper in
            ("\(type(of: wrapper.expression))", wrapper)
        }
        let expressionsByType = Dictionary(expressionsTypeTuples) { lhs, rhs in
            lhs + rhs
        }
        expressions = Array(expressionsByType.values)
    }
    
    func f(x: Number) -> Number {
        expressions.map { expWrapper in
            expWrapper.eval(x: x)
        }.sum
    }
    
    func equalTo(_ other: Function<Number>) -> Bool {
        expressions == other.expressions
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
        let sum = Function(lhs.expressions + rhs.expressions)
        sum.reduceExpressions()
        return sum as! Self
    }
    
    func negated() -> Self {
        let wrappers = expressions.map { wrapper in
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

//public class CompoundFunction<Number: Finite>: Function<Number> {
//    var functions: Set<Function<Number>>
//
//    init(functions: Function<Number>...) {
//        self.functions = Set(functions)
//    }
//
//    override func f(x: Number) -> Number {
//        functions.map { function in
//            function.f(x: x)
//        }.sum
//    }
//}

public protocol Differentiable: Expression {
    func nthDerivative(n: N) -> any Expression
}

public protocol Integrable: Expression {
    func nthIntegral(n: N) -> any Expression
}

