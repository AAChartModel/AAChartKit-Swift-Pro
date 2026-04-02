//
//  AAChart+Options3D.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

private var aaChartOptions3DKey: UInt8 = 0

public extension AAChart {
    var options3d: AAOptions3D? {
        get {
            objc_getAssociatedObject(self, &aaChartOptions3DKey) as? AAOptions3D
        }
        set {
            objc_setAssociatedObject(self, &aaChartOptions3DKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    func options3d(_ prop: AAOptions3D?) -> AAChart {
        options3d = prop
        return self
    }
}

extension AAChart: AASerializableWithComputedProperties {
    public func computedProperties() -> [String: Any] {
        var dict = [String: Any]()
        if let options3d {
            dict["options3d"] = options3d.toDic()
        }
        return dict
    }
}
