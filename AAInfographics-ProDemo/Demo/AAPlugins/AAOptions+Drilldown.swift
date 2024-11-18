//
//  AAOptions+Drilldown.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/11/18.
//

import Foundation

//为 AAOptions 添加 drilldown 属性

// 定义关联对象的键 drilldownKey
private var drilldownKey: UInt8 = 0

public extension AAOptions {
    var drilldown: AADrilldown? {
        get {
            return objc_getAssociatedObject(self, &drilldownKey) as? AADrilldown
        }
        set {
            objc_setAssociatedObject(self, &drilldownKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func drilldown(_ prop: AADrilldown?) -> AAOptions {
        drilldown = prop
        return self
    }
}

//// 遵循协议以提供计算属性
//extension AAChart: SerializableWithComputedProperties {
//    public func computedProperties() -> [String: Any] {
//        return [
//            "nickname": nickname as Any
//        ]
//    }
//}

//遵循协议以提供计算属性
extension AAOptions: SerializableWithComputedProperties {
    public func computedProperties() -> [String: Any] {
        return [
            "drilldown": drilldown?.toDic() as Any
        ]
    }
}
