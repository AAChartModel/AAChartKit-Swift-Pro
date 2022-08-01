//
//  AAItem.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/1.
//


public class AAItem: AAObject {
    public var name: String?
    public var data: [Any]?
    public var keys: [String]?
    public var dataLabels:AADataLabels?
    public var size: Float?
    public var allowPointSelect: Bool?
    public var cursor: String?
    public var showInLegend: Bool?
    public var startAngle: Float?
    public var endAngle: Float?
    public var center: [Int]?
    
    @discardableResult
    public func name(_ prop: String?) -> AAItem {
        name = prop
        return self
    }
    
    @discardableResult
    public func data(_ prop: [Any]?) -> AAItem {
        data = prop
        return self
    }
    
    @discardableResult
    public func keys(_ prop: [String]?) -> AAItem {
        keys = prop
        return self
    }
    
    @discardableResult
    public func dataLabels(_ prop: AADataLabels?) -> AAItem {
        dataLabels = prop
        return self
    }
    
    @discardableResult
    public func size(_ prop: Float?) -> AAItem {
        size = prop
        return self
    }
    
    @discardableResult
    public func allowPointSelect(_ prop: Bool?) -> AAItem {
        allowPointSelect = prop
        return self
    }
    
    @discardableResult
    public func cursor(_ prop: String) -> AAItem {
        cursor = prop
        return self
    }
    
    @discardableResult
    public func showInLegend(_ prop: Bool?) -> AAItem {
        showInLegend = prop
        return self
    }
    
    @discardableResult
    public func startAngle(_ prop: Float?) -> AAItem {
        startAngle = prop
        return self
    }
    
    @discardableResult
    public func endAngle(_ prop: Float?) -> AAItem {
        endAngle = prop
        return self
    }
    
    @discardableResult
    public func center(_ prop: [Int]?) -> AAItem {
        center = prop
        return self
    }
    
    public override init() {
        
    }
    
}
