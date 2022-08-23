import Foundation

public struct Parameterization<P: Finite> {
    var range: ClosedRange<P>
    var expression: any Expression
}
