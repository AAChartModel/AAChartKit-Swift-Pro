//
//  AAParallelAxes.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/6.
//

import Foundation

/**
 drilldown: {
       breadcrumbs: {
           position: {
               align: 'right'
           }
       },
       series: [
           {
               name: 'Chrome',
               id: 'Chrome',
               data: [
 */
public class AADrilldown: AAObject {
    public var breadcrumbs: AABreadcrumbs?
    public var series: [AASeriesElement]?
    
    @discardableResult
    public func breadcrumbs(_ prop: AABreadcrumbs?) -> AADrilldown {
        breadcrumbs = prop
        return self
    }
    
    @discardableResult
    public func series(_ prop: [AASeriesElement]?) -> AADrilldown {
        series = prop
        return self
    }
    
    public override init() {
        
    }
}


public class AABreadcrumbs: AAObject {
    public var position: AAPosition?
    
    @discardableResult
    public func position(_ prop: AAPosition?) -> AABreadcrumbs {
        position = prop
        return self
    }
    
    public override init() {
        
    }
}



/**
 data: [
                {
                    name: 'Chrome',
                    y: 63.06,
                    drilldown: 'Chrome'
                },
                {
                    name: 'Safari',
                    y: 19.84,
                    drilldown: 'Safari'
                },
 */
public class AADrilldownDataElement: AAObject {
    public var name: String?
    public var y: Float?
    public var drilldown: String?
    
    @discardableResult
    public func name(_ prop: String?) -> AADrilldownDataElement {
        name = prop
        return self
    }
    
    @discardableResult
    public func y(_ prop: Float?) -> AADrilldownDataElement {
        y = prop
        return self
    }
    
    @discardableResult
    public func drilldown(_ prop: String?) -> AADrilldownDataElement {
        drilldown = prop
        return self
    }
    
    public override init() {
        
    }
}
