//
//  BigUIntExtension.swift
//  
//
//  Created by Joseph Cestone on 8/26/22.
//

import Foundation
import BigInt

extension BigUInt {
    var primeFactorization: [BigUInt] {
        var factors: [BigUInt] = []
        var currentFactor:BigUInt = 2
        var currentQuotient = self
        while currentQuotient != 1 {
            let divisibleByCurrent = (currentQuotient % currentFactor) == 0
            if divisibleByCurrent {
                factors.append(currentFactor)
                currentQuotient = currentQuotient / currentFactor
                currentFactor = 2
            } else {
                currentFactor += 1
            }
        }
        return factors
    }
    
    var primeFactorsDictionary: [BigUInt:BigUInt] {
        let tuples = primeFactorization.map { ($0, BigUInt(1)) }
        return Dictionary(tuples) { lhs, rhs in
            lhs + rhs
        }
    }
    
    func nextFactors(soFar: Set<BigUInt>, availableFactors: Dictionary<BigUInt, BigUInt>.Keys) -> Set<BigUInt> {
        print("soFar ", soFar)
        print("available ", availableFactors)
        return Set(soFar.flatMap { factor in
            availableFactors.map { availableFactor in
                factor * availableFactor
            }
        })
    }
    
    public var uniqueFactors: Set<BigUInt> {
        var primesDict = primeFactorsDictionary
        var factorsSoFar: Set<BigUInt> = [1]
        
        primesDict.forEach { factor, power in
            var powerRemaining = power
            var newFactors: Set<BigUInt> = []
            var previousFactors = factorsSoFar
            
            for _ in 1...powerRemaining {
                previousFactors = previousFactors .* factor
                newFactors.formUnion(
                    previousFactors
                )
            }
            
            factorsSoFar.formUnion(newFactors)
        }
        
        return factorsSoFar
    }
    
    static func commonFactorDictionary(_ lhs: BigUInt, _ rhs: BigUInt) -> [BigUInt:BigUInt] {
        
        let lhsFactors = lhs.primeFactorsDictionary
        let rhsFactors = rhs.primeFactorsDictionary
        
        let lhsContribution = lhsFactors.filter { key, value in
            rhsFactors[key] != nil
        }
        print("lhsContribution ", lhsContribution)
        let rhsContribution = rhsFactors.filter { key, value in
            lhsFactors[key] != nil
        }
        print("rhsContribution ", rhsContribution)
        return lhsContribution.merging(rhsContribution) { lhsPower, rhsPower in
            Swift.min(lhsPower, rhsPower)
        }
    }
    static func unionOfFactorsDictionary(_ lhs: BigUInt, _ rhs: BigUInt) -> [BigUInt:BigUInt] {
        let lhsFactors = lhs.primeFactorsDictionary
        let rhsFactors = rhs.primeFactorsDictionary
        return lhsFactors.merging(rhsFactors) { lhsPower, rhsPower in
            Swift.max(lhsPower, rhsPower)
        }
    }
    static func lcm(_ lhs: BigUInt, _ rhs: BigUInt) -> BigUInt {
        if lhs == 0 || rhs == 0 { return 0 }
        
        let unionOfFactors = unionOfFactorsDictionary(lhs, rhs)
        return unionOfFactors.map { factor, power in
            var result:BigUInt = 1
            for _ in 1...power {
                result *= power
            }
            return result
        }.product
    }
}
