//
//  AAOptions+ZAxis.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

private var aaOptionsZAxisKey: UInt8 = 0

public extension AAOptions {
    var zAxis: AAZAxis? {
        get {
            objc_getAssociatedObject(self, &aaOptionsZAxisKey) as? AAZAxis
        }
        set {
            objc_setAssociatedObject(self, &aaOptionsZAxisKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    func zAxis(_ prop: AAZAxis?) -> AAOptions {
        zAxis = prop
        return self
    }
}
