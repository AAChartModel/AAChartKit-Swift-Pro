//
//  AAOptions3D.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

public class AAOptions3D: AAObject {
    public var enabled: Bool?
    public var alpha: Float?
    public var beta: Float?
    public var depth: Float?
    public var viewDistance: Float?
    public var fitToPlot: Bool?
    public var frame: AAFrame?

    @discardableResult
    public func enabled(_ prop: Bool?) -> AAOptions3D {
        enabled = prop
        return self
    }

    @discardableResult
    public func alpha(_ prop: Float?) -> AAOptions3D {
        alpha = prop
        return self
    }

    @discardableResult
    public func beta(_ prop: Float?) -> AAOptions3D {
        beta = prop
        return self
    }

    @discardableResult
    public func depth(_ prop: Float?) -> AAOptions3D {
        depth = prop
        return self
    }

    @discardableResult
    public func viewDistance(_ prop: Float?) -> AAOptions3D {
        viewDistance = prop
        return self
    }

    @discardableResult
    public func fitToPlot(_ prop: Bool?) -> AAOptions3D {
        fitToPlot = prop
        return self
    }

    @discardableResult
    public func frame(_ prop: AAFrame?) -> AAOptions3D {
        frame = prop
        return self
    }
}

public class AAFrame: AAObject {
    public var bottom: [String: Any]?
    public var back: [String: Any]?
    public var side: [String: Any]?

    @discardableResult
    public func bottom(_ prop: [String: Any]?) -> AAFrame {
        bottom = prop
        return self
    }

    @discardableResult
    public func back(_ prop: [String: Any]?) -> AAFrame {
        back = prop
        return self
    }

    @discardableResult
    public func side(_ prop: [String: Any]?) -> AAFrame {
        side = prop
        return self
    }
}

public class AAZAxis: AAObject {
    public var min: Float?
    public var max: Float?
    public var categories: [Any]?
    public var labels: AALabels?
    public var showFirstLabel: Bool?

    @discardableResult
    public func min(_ prop: Float?) -> AAZAxis {
        min = prop
        return self
    }

    @discardableResult
    public func max(_ prop: Float?) -> AAZAxis {
        max = prop
        return self
    }

    @discardableResult
    public func categories(_ prop: [Any]?) -> AAZAxis {
        categories = prop
        return self
    }

    @discardableResult
    public func labels(_ prop: AALabels?) -> AAZAxis {
        labels = prop
        return self
    }

    @discardableResult
    public func showFirstLabel(_ prop: Bool?) -> AAZAxis {
        showFirstLabel = prop
        return self
    }
}
