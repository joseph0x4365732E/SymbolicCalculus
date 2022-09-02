//
//  ScalarType.swift
//  
//
//  Created by Joseph Cestone on 8/28/22.
//

import Foundation

public enum ScalarType {
    case fraction
    case double
    case float
    case float16
    case any
    
    var exactnessPriority: Int {
        switch self {
        case .double:   return 4;
        case .float:    return 3;
        case .float16:  return 2;
        case .fraction: return 1;
        case .any:      return 0;
        }
    }
}

extension ScalarType: Comparable {
    public static func < (lhs: ScalarType, rhs: ScalarType) -> Bool {
        return lhs.exactnessPriority < rhs.exactnessPriority
    }
}

extension ScalarType {
    init(combining sca1: ScalarType, _ sca2: ScalarType) {
        self = Swift.min(sca1, sca2)
    }
}
