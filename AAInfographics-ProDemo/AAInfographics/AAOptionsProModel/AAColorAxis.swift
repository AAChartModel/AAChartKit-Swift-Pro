//
//  AAColorAxis.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

public class AAColorAxis: AAObject {
    public var min: Any?
    public var minColor: String?
    public var maxColor: String?
    public var dataClasses: [AADataClasses]?
    
    @discardableResult
    public func min(_ prop: Any?) -> AAColorAxis {
        min = prop
        return self
    }
    
    @discardableResult
    public func minColor(_ prop: String?) -> AAColorAxis {
        minColor = prop
        return self
    }
    
    @discardableResult
    public func maxColor(_ prop: String?) -> AAColorAxis {
        maxColor = prop
        return self
    }
    
    @discardableResult
    public func dataClasses(_ prop: [AADataClasses]?) -> AAColorAxis {
        dataClasses = prop
        return self
    }
    
    public override init() {
        
    }
    
}

public class AADataClasses: AAObject {
    public var from: Any?
    public var to: Any?
    public var color: String?
    public var name: String?
    
    @discardableResult
    public func from(_ prop: Any?) -> AADataClasses {
        from = prop
        return self
    }
    
    @discardableResult
    public func to(_ prop: Any?) -> AADataClasses {
        to = prop
        return self
    }
    
    @discardableResult
    public func color(_ prop: String?) -> AADataClasses {
        color = prop
        return self
    }
    
    @discardableResult
    public func name(_ prop: String?) -> AADataClasses {
        name = prop
        return self
    }
    
    public override init() {
        
    }
    
}
