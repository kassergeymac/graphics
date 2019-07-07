//
//  Axis.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/17/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit


struct GraphLine:Equatable {
    
    let id: String
    
    var name: String?
    var color: UIColor?
    
    var values: Array<Float>
    
    static func ==(lhs: GraphLine, rhs: GraphLine) -> Bool
    {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.color != rhs.color {
            return false
        }
        if lhs.values != rhs.values {
            return false
        }
        return true
    }
}
