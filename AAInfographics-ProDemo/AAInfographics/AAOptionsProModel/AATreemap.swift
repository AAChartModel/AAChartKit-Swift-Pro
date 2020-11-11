//
//  AATreemap.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

public class AATreemap: AAObject {
    public var layoutAlgorithm: String?
    public var allowTraversingTree: Bool?
    
    @discardableResult
    public func layoutAlgorithm(_ prop: String?) -> AATreemap {
        layoutAlgorithm = prop
        return self
    }
    
    @discardableResult
    public func allowTraversingTree(_ prop: Bool?) -> AATreemap {
        allowTraversingTree = prop
        return self
    }
    
    public override init() {
        
    }

}
