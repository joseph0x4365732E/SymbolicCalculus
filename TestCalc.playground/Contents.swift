import SymbolicCalculus


let parser = ExpressionParser(exact: true)


func result(evaluating input: String) -> String {
    let expression = try! parser.parse(input: input)
    return expression.simplified().description
}

result(evaluating: " 1 - 1")
result(evaluating: " 1 - -1")
