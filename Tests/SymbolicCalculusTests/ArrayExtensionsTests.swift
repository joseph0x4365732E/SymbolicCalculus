//
//  ArrayExtensionsTests.swift
//  
//
//  Created by Joseph Cestone on 8/22/22.
//

import XCTest
@testable import SymbolicCalculus

final class ArrayExtensionsTests: XCTestCase {

    func testcumulativeSum() throws {
        XCTAssertEqual([1, 2, 3.0].cumulativeSum, [1, 3, 6.0])
    }

    func testBinarySearch() {
        XCTAssertEqual([1].orderedBinarySearch(firstIndexWhere: { $0 > 0 }), 0)
        XCTAssertEqual([1].orderedBinarySearch(firstIndexWhere: { $0 > 1 }), nil)
    }
    
    func testZeroRange() {
        let zero = ClosedRange<Int>.empty
        var foundOne = false
        for _ in 0...100_000 {
            if zero.contains(Int.random(in: Int.min...Int.max)) {
                foundOne = true
            }
        }
        XCTAssertEqual(foundOne, false)
        
        XCTAssertEqual(zero.relative(to: Array(-100...100)), 0..<0)
        XCTAssertFalse(zero.isEmpty) // not intended
        XCTAssertEqual(zero.lowerBound, 0)
        XCTAssertEqual(zero.upperBound, -1)
        XCTAssertFalse(zero ~= 1)
        //zero.clamped(to)
        XCTAssertEqual(zero, zero)
        XCTAssertNotEqual(zero, 0...0)
        XCTAssertFalse(zero.overlaps(0...0))
        XCTAssertFalse(zero.overlaps(-1...(-1)))
        XCTAssert(zero.overlaps(-1...0)) // not intended
        XCTAssertEqual(zero.hashValue, zero.hashValue)
        XCTAssertEqual(zero.description, "0...-1")
        XCTAssertEqual(zero.debugDescription, "ClosedRange(0...-1)")
        XCTAssertEqual(zero.lowerBound, 0)
        XCTAssertEqual(zero.upperBound, -1) // make sure getting the description did not change anything
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(zero)
        XCTAssertNotNil(encoded)
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(ClosedRange<Int>.self, from: encoded!)
        XCTAssertNil(decoded) // not intended
        XCTAssertNotEqual(zero, decoded)
    }
    
    func testRangeIntersection() {
        let zero = (0...0).intersection(with: 1...1)
        XCTAssertEqual(zero, ClosedRange<Int>.empty)
        let intersection = (0...4).intersection(with: 2...6)
        XCTAssertEqual(intersection, 2...4)
        let intersection2 = (-10...40).intersection(with: -22...65)
        XCTAssertEqual(intersection2, -10...40)
    }
}
