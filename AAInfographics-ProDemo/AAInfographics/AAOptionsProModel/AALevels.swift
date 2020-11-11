//
//  AALevels.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

public class AALevels: AAObject {
    public var borderColor: String?
    public var borderDashStyle: String?
    public var borderWidth: Any?
    public var color: String?
    public var colorByPoint: Any?
    public var dataLabels: AADataLabels?
    public var layoutAlgorithm: String?
    public var layoutStartingDirection: String?
    public var level: Any?
    public var colorVariation: Any?
    
    @discardableResult
    public func borderColor(_ prop: String?) -> AALevels {
        borderColor = prop
        return self
    }
    
    @discardableResult
    public func borderDashStyle(_ prop: String?) -> AALevels {
        borderDashStyle = prop
        return self
    }
    
    @discardableResult
    public func borderWidth(_ prop: Any?) -> AALevels {
        borderWidth = prop
        return self
    }
    
    @discardableResult
    public func color(_ prop: String?) -> AALevels {
        color = prop
        return self
    }
    
    @discardableResult
    public func colorByPoint(_ prop: Any?) -> AALevels {
        colorByPoint = prop
        return self
    }
    
    @discardableResult
    public func dataLabels(_ prop: AADataLabels?) -> AALevels {
        dataLabels = prop
        return self
    }
    
    @discardableResult
    public func layoutAlgorithm(_ prop: String?) -> AALevels {
        layoutAlgorithm = prop
        return self
    }
    
    @discardableResult
    public func layoutStartingDirection(_ prop: String?) -> AALevels {
        layoutStartingDirection = prop
        return self
    }
    
    @discardableResult
    public func level(_ prop: Any?) -> AALevels {
        level = prop
        return self
    }
    
    @discardableResult
    public func colorVariation(_ prop: AAColorVariation?) -> AALevels {
        colorVariation = prop
        return self
    }
    
    public override init() {
        
    }
    
}

public class AAColorVariation: AAObject {
    public var key: String?
    public var to: Any?
    
    @discardableResult
    public func key(_ prop: String?) -> AAColorVariation {
        key = prop
        return self
    }
    
    @discardableResult
    public func to(_ prop: Any?) -> AAColorVariation {
        to = prop
        return self
    }
    
    public override init() {
        
    }
    
}
