//
//  AAStringExtension.swift
//  AAInfographicsDemo
//
//  Created by AnAn on 2020/8/11.
//  Copyright © 2020 An An. All rights reserved.
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
import ObjectiveC

public extension AAStyle {
    convenience init(color : String?) {
        self.init(color: color, fontSize: nil)
    }
    
    convenience init(color : String?, fontSize: Float?) {
        self.init(color: color, fontSize: fontSize,weight: nil)
    }
    
    convenience init(color : String?, fontSize: Float?, weight: AAChartFontWeightType?) {
      self.init(color: color, fontSize: fontSize,weight: weight, outline: nil)
    }
    
    convenience init(color : String?, fontSize: Float?, weight: AAChartFontWeightType?, outline: String?) {
        self.init()
        self.color(color)
        .fontSize(fontSize)
        .fontWeight(weight)
        .textOutline(outline)
    }
}

public extension String {
    
    func aa_toPureJSString() -> String {
        //https://stackoverflow.com/questions/34334232/why-does-function-not-work-but-function-does-chrome-devtools-node
        var pureJSStr = "(\(self))"
        pureJSStr = pureJSStr.replacingOccurrences(of: "'", with: "\"")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\0", with: "")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\n", with: "")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\\", with: "\\\\")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\"", with: "\\\"")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\n", with: "\\n")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\r", with: "\\r")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{000C}", with: "\\f")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        return pureJSStr
    }
    
}


public extension Array {
    
    //Convert Swift array to be JavaScript array
    func aa_toJSArray() -> String {
        var originalJsArrStr = ""
        for element in self {
            originalJsArrStr = originalJsArrStr + "'\(element)',"
        }
        
        return "[\(originalJsArrStr)]"
    }
    
}


public extension AAChartModel {
    
    //Convert AAChartModel to be AAOptions
    func aa_toAAOptions() -> AAOptions {
        AAOptionsConstructor.configureChartOptions(self)
    }
}


// 定义关联对象的键
private var NicknameKey: UInt8 = 0

// 扩展 Person 类
public extension AAChart {
    // 计算属性来设置和获取 nickname
    var nickname: String? {
        get {
            return objc_getAssociatedObject(self, &NicknameKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &NicknameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    @discardableResult
    func nickname(prop: String?) -> AAChart {
        nickname = prop
        return self
    }
}

// 遵循协议以提供计算属性
extension AAChart: AASerializableWithComputedProperties {
    public func computedProperties() -> [String: Any] {
        return [
            "nickname": nickname as Any
        ]
    }
}


