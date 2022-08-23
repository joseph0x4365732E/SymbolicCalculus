//
//  ArrayExtension.swift
//  
//
//  Created by Joseph Cestone on 8/17/22.
//

import Foundation

public extension Array where Element: AdditiveArithmetic {
    var sum: Element { reduce(Element.zero, +) }
    
    var cumulativeSum: [Element] {
        var result = [Element]()
        result.reserveCapacity(count)
        var runningSum:Element = .zero
        for idx in 0..<count {
            runningSum += self[idx]
            result.append(runningSum)
        }
        return result
    }
    
    func orderedBinarySearch(firstIndexWhere: (Element) -> Bool) -> Int? {
        var highestFalseYet = -1
        var lowestTrueYet = count
        while true {
            if lowestTrueYet - highestFalseYet == 1 {
                break
            }
            let checkNext = (highestFalseYet + lowestTrueYet) / 2
            if firstIndexWhere(self[checkNext]) {
                // found lowest true yet
                lowestTrueYet = checkNext
            } else {
                // found highest false yet
                highestFalseYet = checkNext
            }
        }
        if lowestTrueYet == count {
            return nil
        }
        return lowestTrueYet
    }
}

extension ClosedRange where Bound: ExpressibleByIntegerLiteral {
    init() {
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
    
    func intersection(with other: Self) -> Self {
        let newLowerBound = Swift.max(lowerBound, other.lowerBound)
        let newUpperBound = Swift.min(upperBound, other.upperBound)
        
        guard newLowerBound < newUpperBound else {
            return Self()
        }
        return newLowerBound...newUpperBound
    }
}
