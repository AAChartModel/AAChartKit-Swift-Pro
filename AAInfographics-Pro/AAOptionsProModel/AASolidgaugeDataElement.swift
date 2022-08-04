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
    public override func name(_ prop: String) -> AASolidgaugeDataElement {
        name = prop
        return self
    }
    
    @discardableResult
    public override func x(_ prop: Float) -> AASolidgaugeDataElement {
        x = prop
        return self
    }
    
    @discardableResult
    public override func y(_ prop: Float) -> AASolidgaugeDataElement {
        y = prop
        return self
    }
    
    @discardableResult
    public override func color(_ prop: Any) -> AASolidgaugeDataElement {
        color = prop
        return self
    }
    
    @discardableResult
    public override func dataLabels(_ prop: AADataLabels) -> AASolidgaugeDataElement {
        dataLabels = prop
        return self
    }
    
    @discardableResult
    public override func marker(_ prop: AAMarker) -> AASolidgaugeDataElement {
        marker = prop
        return self
    }
    
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
