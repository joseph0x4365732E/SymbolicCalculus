//
//  PolynomialTests.swift
//  
//
//  Created by Joseph Cestone on 8/22/22.
//

import XCTest
@testable import SymbolicCalculus

final class PolynomialTests: XCTestCase {

    func testTerms() throws {
        let polyA = Polynomial(standardCoefficients: 1, 2, 3, 4)
        let coefficents = polyA.terms.map { nomial in
            nomial.coefficient
        }
        let powers = polyA.terms.map { nomial in
            nomial.power
        }
        XCTAssertEqual(powers, polyA.powers)
        XCTAssertEqual(coefficents, [1, 2, 3, 4])
        XCTAssertEqual(powers, [3, 2, 1, 0])
    }
    
    func testString() throws {
        let polyA = Polynomial(standardCoefficients: 1, 2)
        XCTAssertEqual(String(describing: polyA), "1.0x^1 + 2.0x^0")
    }
    
    func testAddition() throws {
        let X = Polynomial(standardCoefficients: 1, 7, 5, 1, 2, 3)
        XCTAssertEqual(X.coefficientsByPower, [0:3, 1:2, 2:1, 3:5, 4:7, 5:1])
        let Y = Polynomial(standardCoefficients: 1, 3, 9, 8, 7)
        let sum = Polynomial(standardCoefficients: 1, 8, 8, 10, 10, 10)
        
        XCTAssertEqual(X + Y, sum)
        
    }
    
    func testIdentities() throws {
        let X = Polynomial<Double>(standardCoefficients: 1, 7, 5, 1, 2, 3)
        let Y = Polynomial(standardCoefficients: 1, 3, 9, 8, 7)
        let Z = Polynomial(standardCoefficients: 2, 0, 8, 3, 7)
        
        /// 1. Commutativity:
        XCTAssertEqual(X + Y, Y + X)
        
        ///2. Associativity of vector addition:
        XCTAssertEqual((X+Y)+Z, X+(Y+Z))
        
        ///3. Additive identity: For all X,
        XCTAssertEqual(0 + X, X + 0)
        XCTAssertEqual(0 + X, X)
        
        ///4. Existence of additive inverse: For any X, there exists a -X such that
        XCTAssertEqual(X + (-X), 0)
        
        ///5. Associativity of multiplication:
        XCTAssertEqual(Y * (Z * X), (Y * Z) * X)
        
        ///6. Distributivity of sums:
        XCTAssertEqual((Y + Z) * X, Y * X + Z * X)
        
        ///8. Scalar multiplication identity:
        XCTAssertEqual(1 * X, X)
        
        ///Multiplication by zero
        XCTAssertEqual(0 * X, 0)
    }
    
    func testZero() {
        let zero = Polynomial<Double>.zero
        XCTAssertEqual(zero, 0)
        let range = -(1.0e-100)...(1.0e+100)
        let val = zero.eval(x: Double.random(in: range))
        XCTAssertEqual(val, 0)
    }
    
    func testMultiply() throws {
        let polyA = Polynomial(standardCoefficients: 1, 2)
        let polyB = Polynomial(standardCoefficients: 1, 5)
        let polyC = Polynomial(standardCoefficients: 1, 7, 10)
        XCTAssertEqual(polyA * polyB, polyC)
    }
    
    func testLimitsAsX() {
        
    }
}
