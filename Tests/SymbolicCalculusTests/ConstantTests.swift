//
//  ConstantTests.swift
//  
//
//  Created by Joseph Cestone on 11/1/22.
//

import XCTest
@testable import SymbolicCalculus

final class ConstantTests: XCTestCase {
    func testSubtraction() {
        let fracA = Fraction(whole: 1)
        let fracB = Fraction(whole: 1)
        
        XCTAssertEqual(
            AnyExpression(
                Constant(fracA).minus(Constant(fracB)).simplified()
            ),
            AnyExpression(
                Constant(Fraction(whole: 0))
            )
        )
    }
}
