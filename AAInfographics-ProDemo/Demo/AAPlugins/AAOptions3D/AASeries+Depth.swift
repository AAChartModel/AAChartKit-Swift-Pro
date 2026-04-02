//
//  AASeries+Depth.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

private var aaSeriesGroupZPaddingKey: UInt8 = 0
private var aaSeriesDepthKey: UInt8 = 0
private var aaSeriesGroupingKey: UInt8 = 0

public extension AASeries {
    var groupZPadding: Float? {
        get {
            (objc_getAssociatedObject(self, &aaSeriesGroupZPaddingKey) as? NSNumber)?.floatValue
        }
        set {
            objc_setAssociatedObject(self, &aaSeriesGroupZPaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var depth: Float? {
        get {
            (objc_getAssociatedObject(self, &aaSeriesDepthKey) as? NSNumber)?.floatValue
        }
        set {
            objc_setAssociatedObject(self, &aaSeriesDepthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var grouping: Bool? {
        get {
            (objc_getAssociatedObject(self, &aaSeriesGroupingKey) as? NSNumber)?.boolValue
        }
        set {
            objc_setAssociatedObject(self, &aaSeriesGroupingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    func groupZPadding(_ prop: Float?) -> AASeries {
        groupZPadding = prop
        return self
    }

    @discardableResult
    func depth(_ prop: Float?) -> AASeries {
        depth = prop
        return self
    }

    @discardableResult
    func grouping(_ prop: Bool?) -> AASeries {
        grouping = prop
        return self
    }
}
