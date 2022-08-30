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

infix operator .* : MultiplicationPrecedence
extension Sequence where Element: Numeric & Hashable {
    var product: Element {
        reduce(1, *)
    }
    
    static func .* (lhs: Self, rhs: Element) -> Self {
        let arr = lhs.map { $0 * rhs }
        
        switch lhs {
        case is Array<Element>: return arr as! Self
        case is Set<Element>: return Set(arr) as! Self
        default: fatalError("Unsupported type \(type(of: lhs))")
        }
    }
    
}

infix operator ./ : MultiplicationPrecedence
extension Array where Element: Divisible {
    static func ./ (lhs: Self, rhs: Element) -> Self {
        return lhs.map { $0 / rhs }
    }
    
    static func ./ (lhs: Element, rhs: Self) -> Self {
        return rhs.map { lhs / $0 }
    }
}
