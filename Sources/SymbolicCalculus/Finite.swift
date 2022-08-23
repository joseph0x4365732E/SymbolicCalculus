//
//  Finite.swift
//  
//
//  Created by Joseph Cestone on 8/18/22.
//

import Foundation

public protocol Finite: SignedNumeric, Hashable, Comparable {
    static var min: Self { get }
    static var max: Self { get }
}

extension Double: Finite {
    public static var min: Double { -.greatestFiniteMagnitude }
    public static var max: Double { .greatestFiniteMagnitude }
}

extension Float: Finite {
    public static var min: Float { -.greatestFiniteMagnitude }
    public static var max: Float { .greatestFiniteMagnitude }
}

@available(macOS 11.0, *)
@available(iOS 14.0, *)
extension Float16: Finite {
    public static var min: Float16 { -.greatestFiniteMagnitude }
    public static var max: Float16 { .greatestFiniteMagnitude }
}

extension Int: Finite {
    public static var min: Int { -.max }
    //public static var max: Int { Int.max }
}

extension Int8: Finite {
    public static var min: Int8 { -.max }
   // public static var max: Int8 { .max }
}

extension Int16: Finite {
    public static var min: Int16 { -.max }
    //public static var max: Int16 { .max }
}

extension Int32: Finite {
    public static var min: Int32 { -.max }
    //public static var max: Int32 { .max }
}

extension Int64: Finite {
    public static var min: Int64 { -.max }
    //public static var max: Int64 { .max }
}
