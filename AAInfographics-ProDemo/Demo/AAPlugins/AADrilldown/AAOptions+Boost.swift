//
//  AAOptions+Drilldown.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/11/18.
//

import Foundation

//为 AAOptions 添加 drilldown 属性

// 定义关联对象的键 boost
private var boostKey: UInt8 = 0

public extension AAOptions {
    var boost: AABoost? {
        get {
            return objc_getAssociatedObject(self, &boostKey) as? AABoost
        }
        set {
            objc_setAssociatedObject(self, &boostKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func boost(_ prop: AABoost?) -> AAOptions {
        boost = prop
        return self
    }
}



//遵循协议以提供计算属性
//extension AAOptions: SerializableWithComputedProperties {
//    public func computedProperties() -> [String: Any] {
//        return [
//            "boost": boost?.toDic() as Any
//        ]
//    }
//}
