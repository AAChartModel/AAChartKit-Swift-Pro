//
//  AAPackedbubble.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

public class AAPackedbubble: AAObject {
    public var minSize: String?
    public var maxSize: String?
    public var zMin: Any?
    public var zMax: Any?
    public var layoutAlgorithm: AALayoutAlgorithm?
    public var dataLabels: AADataLabels?
    
    @discardableResult
    public func minSize(_ prop: String?) -> AAPackedbubble {
        minSize = prop
        return self
    }
    
    @discardableResult
    public func maxSize(_ prop: String?) -> AAPackedbubble {
        maxSize = prop
        return self
    }
    
    @discardableResult
    public func zMin(_ prop: Any?) -> AAPackedbubble {
        zMin = prop
        return self
    }
    
    @discardableResult
    public func zMax(_ prop: Any?) -> AAPackedbubble {
        zMax = prop
        return self
    }
    
    @discardableResult
    public func layoutAlgorithm(_ prop: AALayoutAlgorithm?) -> AAPackedbubble {
        layoutAlgorithm = prop
        return self
    }
    
    @discardableResult
    public func dataLabels(_ prop: AADataLabels?) -> AAPackedbubble {
        dataLabels = prop
        return self
    }
    
    public override init() {
        
    }
    
}
