//
//  AAParallelAxes.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/6.
//

import Foundation

public class AAParallelAxes {
    public var lineWidth: Float?
    
    @discardableResult
    public func lineWidth(_ prop: Float?) -> AAParallelAxes {
        lineWidth = prop
        return self
    }
}
