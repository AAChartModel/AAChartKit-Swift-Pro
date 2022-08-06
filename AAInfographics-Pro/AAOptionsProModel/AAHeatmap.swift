//
//  AAHeatmap.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/5.
//

import Foundation

public class AAHeatmap: AAObject {
    public var borderWidth: Float?
    public var nullColor: String?
    public var colsize: Float?
    public var tooltip: AATooltip?
    public var data: [Any]?
    public var turboThreshold: Double?
    
    @discardableResult
    public func borderWidth(_ prop: Float?) -> AAHeatmap {
        borderWidth = prop
        return self
    }
    
    @discardableResult
    public func nullColor(_ prop: String?) -> AAHeatmap {
        nullColor = prop
        return self
    }
    
    @discardableResult
    public func colsize(_ prop: Float?) -> AAHeatmap {
        colsize = prop
        return self
    }
    
    @discardableResult
    public func tooltip(_ prop: AATooltip?) -> AAHeatmap {
        tooltip = prop
        return self
    }
    
    @discardableResult
    public func data(_ prop: [Any]?) -> AAHeatmap {
        data = prop
        return self
    }
    
    @discardableResult
    public func turboThreshold(_ prop: Double?) -> AAHeatmap {
        turboThreshold = prop
        return self
    }
}
