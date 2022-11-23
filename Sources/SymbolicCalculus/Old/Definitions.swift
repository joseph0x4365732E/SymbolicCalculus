//
//  Definitions.swift
//  
//
//  Created by Joseph Cestone on 9/15/22.
//

import Foundation

class Definitions<C: Scalar> {
    var valuesOfVars: [Variable<C>: Constant<C>]
    
    init(valuesOfVars: [Variable<C> : Constant<C>]) {
        self.valuesOfVars = valuesOfVars
    }
}
