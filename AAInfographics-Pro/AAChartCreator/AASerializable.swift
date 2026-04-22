//
//  AASerializable.swift
//  AAChartKit-Swift
//
//  Created by An An  on 17/4/19.
//  Copyright © 2017年 An An . All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 *  🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit-Swift/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/12302132/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */


import Foundation

public class AAObject { }


public extension AAObject {
    var classNameString: String {
        return String(reflecting: type(of: self))
    }
}

public protocol AASerializableWithComputedProperties {
    /// 返回计算属性的键值对
    func computedProperties() -> [String: Any]
}

public extension AAObject {
    fileprivate func unwrap(_ value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == .optional else { return value }
        guard let child = mirror.children.first else { return nil }
        return child.value
    }
    
    fileprivate func loopForMirrorChildren(_ mirrorChildren: Mirror.Children, _ representation: inout [String : Any]) {
        for case let (label?, value) in mirrorChildren {
            guard let unwrapped = unwrap(value) else { continue }
            switch unwrapped {
            case let value as AAObject:
                representation[label] = value.toDic()
            case let value as [AAObject]:
                representation[label] = value.map { $0.toDic() }
            case let value as [Any]:
                let converted = value.compactMap { element -> Any? in
                    guard let elementValue = unwrap(element) else { return nil }
                    if let aaObject = elementValue as? AAObject {
                        return aaObject.toDic()
                    }
                    if let nsObject = elementValue as? NSObject {
                        return nsObject
                    }
                    return elementValue
                }
                representation[label] = converted
            case let value as NSObject:
                representation[label] = value
            default:
                // Ignore any unserializable properties
                break
            }
        }
    }
    
    func toDic() -> [String: Any] {
        var representation = [String: Any]()
        
        // 遍历当前类的反射子属性
        let mirrorChildren = Mirror(reflecting: self).children
        loopForMirrorChildren(mirrorChildren, &representation)
        
        // 遍历父类的反射子属性
        if let superMirrorChildren = Mirror(reflecting: self).superclassMirror?.children,
           !superMirrorChildren.isEmpty {
            loopForMirrorChildren(superMirrorChildren, &representation)
        }
        
        // 如果实现了 SerializableWithComputedProperties 协议，获取计算属性
        if let selfWithComputed = self as? AASerializableWithComputedProperties {
            let computedProps = selfWithComputed.computedProperties()
            for (key, value) in computedProps {
                representation[key] = value
            }
        }
        
        return representation
    }
    
    func toJSON() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: toDic() as Any, options: [])
            guard let jsonStr = String(data: data, encoding: String.Encoding.utf8) else { return "" }
            return jsonStr
        } catch {
            return ""
        }
    }
    
}
