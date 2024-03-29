//
//  AAData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/5.
//

import Foundation

public class AAData: AAObject {
    public var csv: String?
    public var parsed: String?
    
    @discardableResult
    public func csv(_ prop: String?) -> AAData {
        csv = prop
        return self
    }
    
    @discardableResult
    public func parsed(_ prop: String?) -> AAData {
        parsed = prop?.aa_toPureJSString()
        return self
    }
}
