//
//  AASolidgaugeDataElement.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/4.
//

import Foundation

public class AASolidgaugeDataElement: AADataElement {
    public var radius: String?
    public var innerRadius: String?
    
    @discardableResult
    public func radius(_ prop: String) -> AASolidgaugeDataElement {
        radius = prop
        return self
    }
    
    @discardableResult
    public func innerRadius(_ prop: String) -> AASolidgaugeDataElement {
        innerRadius = prop
        return self
    }
    
    public override init() {
        
    }
}
