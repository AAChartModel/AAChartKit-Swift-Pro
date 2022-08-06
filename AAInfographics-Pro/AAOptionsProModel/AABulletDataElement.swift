//
//  AABullet.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/6.
//

import Foundation

public class AABulletDataElement: AAObject {
    public var y: Float?
    public var target: Float?
    
    @discardableResult
    public func y(_ prop: Float?) -> AABulletDataElement {
        y = prop
        return self
    }
    
    @discardableResult
    public func target(_ prop: Float?) -> AABulletDataElement {
        target = prop
        return self
    }

}
