//
//  ParseError.swift
//  
//
//  Created by Joseph Cestone on 10/20/22.
//

import Foundation

/// Represents types of errors arising from parsing a string to `Expression`.
/// Current Cases are:
///  - unexpectedInput(string)
///
///  Provides var `message` for string error message.
public enum ParseError: Error {
    case unexpectedInput(remaining: String)
    
    public var message: String {
        switch self {
        case .unexpectedInput(let remaining):
            return "Unexpected input at: \(remaining)"
        }
    }
}
