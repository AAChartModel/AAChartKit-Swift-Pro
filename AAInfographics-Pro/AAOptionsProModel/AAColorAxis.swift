//
//  AAColorAxis.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

public class AAColorAxis: AAObject {
    public var min: Any?
    public var minColor: String?
    public var maxColor: String?
    public var dataClasses: [AADataClassesElement]?
    public var stops: [Any]?
    public var max: Double? // x-axis maximum
//    public var min: Double? // x-axis minimum  (set to 0, there will be no negative numbers)
    public var startOnTick: Bool? // Whether to force the axis to start on a tick. Use this option with the minPadding option to control the axis start. The default is false.
    public var endOnTick: Bool?// Whether to force the axis to end on a tick. Use this option with the minPadding option to control the axis end. The default is false.
    public var labels: AALabels?
    
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
    public func dataClasses(_ prop: [AADataClassesElement]?) -> AAColorAxis {
        dataClasses = prop
        return self
    }
    
    @discardableResult
    public func stops(_ prop: [Any]?) -> AAColorAxis {
        stops = prop
        return self
    }
    
    @discardableResult
    public func max(_ prop: Double?) -> AAColorAxis {
        max = prop
        return self
    }
    
//    @discardableResult
//    public func min(_ prop: Double?) -> AAColorAxis {
//        min = prop
//        return self
//    }
    
    @discardableResult
    public func startOnTick(_ prop: Bool?) -> AAColorAxis {
        startOnTick = prop
        return self
    }
    
    @discardableResult
    public func endOnTick(_ prop: Bool?) -> AAColorAxis {
        endOnTick = prop
        return self
    }
    
    @discardableResult
    public func labels(_ prop: AALabels?) -> AAColorAxis {
        labels = prop
        return self
    }
    
    public override init() {
        
    }
    
}

public class AADataClassesElement: AAObject {
    public var from: Any?
    public var to: Any?
    public var color: String?
    public var name: String?
    
    @discardableResult
    public func from(_ prop: Any?) -> AADataClassesElement {
        from = prop
        return self
    }
    
    @discardableResult
    public func to(_ prop: Any?) -> AADataClassesElement {
        to = prop
        return self
    }
    
    @discardableResult
    public func color(_ prop: String?) -> AADataClassesElement {
        color = prop
        return self
    }
    
    @discardableResult
    public func name(_ prop: String?) -> AADataClassesElement {
        name = prop
        return self
    }
    
    public override init() {
        
    }
    
}
