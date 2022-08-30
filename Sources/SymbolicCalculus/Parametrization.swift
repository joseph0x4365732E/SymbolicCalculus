import Foundation

public struct Parameterization<P: Scalar> {
    var range: ClosedRange<P>
    var expression: any Expression
}
