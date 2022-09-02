//
//  RangeExtension.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation

extension ClosedRange where Bound: ExpressibleByIntegerLiteral {
    private init() {
        let zero: Bound = 0
        self.init(uncheckedBounds: (lower: zero, upper: zero))
        let boundTypeWidth = MemoryLayout<Bound>.size
        var negativeOne: Bound = -1
        withUnsafeMutableBytes(of: &self) { rangeMutableBuffer in
            let storedBoundWidth = rangeMutableBuffer.count / 2
            guard storedBoundWidth == boundTypeWidth else {
                fatalError("Element requires different bound width")
            }
            rangeMutableBuffer
                .baseAddress!
                .advanced(by: storedBoundWidth)
                .copyMemory(from: &negativeOne, byteCount: boundTypeWidth)
        }
    }
    
    static var empty: ClosedRange<Bound> { ClosedRange<Bound>() }
    
    func intersection(with other: Self) -> Self {
        let newLowerBound = Swift.max(lowerBound, other.lowerBound)
        let newUpperBound = Swift.min(upperBound, other.upperBound)
        
        guard newLowerBound < newUpperBound else {
            return .empty
        }
        return newLowerBound...newUpperBound
    }
}

//extension ClosedRange where Bound: SignedNumeric {
//    func negated() -> ClosedRange<Bound> {
//        
//    }
//}
