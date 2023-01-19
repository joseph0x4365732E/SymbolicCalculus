//
//  Simplifier.swift
//  
//
//  Created by Joseph Cestone on 12/21/22.
//

import Foundation

class Simplifier {
    static func simplify<S: Scalar>(_ exp: AnyExpression<S>) -> AnyExpression<S> {
        if exp.eType.simplifiesToConstant {
            let const = S(exp.eval(x: AnyScalar(S.zero)))
            return AnyExpression(Constant<S>(const))
        }
        return AnyExpression(exp)
    }
    
}
