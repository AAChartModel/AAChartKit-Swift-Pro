//
//  AALayoutAlgorithm.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

public class AALayoutAlgorithm: AAObject {
    public var gravitationalConstant: Any?
    public var splitSeries: Any?
    public var seriesInteraction: Any?
    public var dragBetweenSeries: Any?
    public var parentNodeLimit: Any?
    
    @discardableResult
    public func gravitationalConstant(_ prop: Any?) -> AALayoutAlgorithm {
        gravitationalConstant = prop
        return self
    }
    
    @discardableResult
    public func splitSeries(_ prop: Any?) -> AALayoutAlgorithm {
        splitSeries = prop
        return self
    }
    
    @discardableResult
    public func seriesInteraction(_ prop: Any?) -> AALayoutAlgorithm {
        seriesInteraction = prop
        return self
    }
    
    @discardableResult
    public func dragBetweenSeries(_ prop: Any?) -> AALayoutAlgorithm {
        dragBetweenSeries = prop
        return self
    }
    
    @discardableResult
    public func parentNodeLimit(_ prop: Any?) -> AALayoutAlgorithm {
        parentNodeLimit = prop
        return self
    }
    
    public override init() {
        
    }
    
}
