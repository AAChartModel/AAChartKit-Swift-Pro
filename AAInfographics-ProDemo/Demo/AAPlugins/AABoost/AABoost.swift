//
//  File.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/11/18.
//

import Foundation

/**
 boost:{
 allowForce:true
 debug:{
 showSkipSummary:false
 timeBufferCopy:false
 timeKDTree:false
 timeRendering:false
 timeSeriesProcessing:false
 timeSetup:false
 }
 enabled:true
 pixelRatio:1
 seriesThreshold:50
 useGPUTranslations:false
 usePreallocated:false
 }
 */
public class AABoost: AAObject {
    public var allowForce: Bool?
    public var debug: AADebug?
    public var enabled: Bool?
    public var pixelRatio: Float?
    public var seriesThreshold: Int?
    public var useGPUTranslations: Bool?
    public var usePreallocated: Bool?
    
    public override init() {
        
    }
    
    @discardableResult
    public func allowForce(_ prop: Bool?) -> AABoost {
        allowForce = prop
        return self
    }
    
    @discardableResult
    public func debug(_ prop: AADebug?) -> AABoost {
        debug = prop
        return self
    }
    
    @discardableResult
    public func enabled(_ prop: Bool?) -> AABoost {
        enabled = prop
        return self
    }
    
    @discardableResult
    public func pixelRatio(_ prop: Float?) -> AABoost {
        pixelRatio = prop
        return self
    }
    
    @discardableResult
    public func seriesThreshold(_ prop: Int?) -> AABoost {
        seriesThreshold = prop
        return self
    }
    
    @discardableResult
    public func useGPUTranslations(_ prop: Bool?) -> AABoost {
        useGPUTranslations = prop
        return self
    }
    
    @discardableResult
    public func usePreallocated(_ prop: Bool?) -> AABoost {
        usePreallocated = prop
        return self
    }
}


public class AADebug: AAObject {
    public var showSkipSummary: Bool?
    public var timeBufferCopy: Bool?
    public var timeKDTree: Bool?
    public var timeRendering: Bool?
    public var timeSeriesProcessing: Bool?
    public var timeSetup: Bool?
    
    public override init() {
        
    }
    
    @discardableResult
    public func showSkipSummary(_ prop: Bool?) -> AADebug {
        showSkipSummary = prop
        return self
    }
    
    @discardableResult
    public func timeBufferCopy(_ prop: Bool?) -> AADebug {
        timeBufferCopy = prop
        return self
    }
    
    @discardableResult
    public func timeKDTree(_ prop: Bool?) -> AADebug {
        timeKDTree = prop
        return self
    }
    
    @discardableResult
    public func timeRendering(_ prop: Bool?) -> AADebug {
        timeRendering = prop
        return self
    }
    
    @discardableResult
    public func timeSeriesProcessing(_ prop: Bool?) -> AADebug {
        timeSeriesProcessing = prop
        return self
    }
    
    @discardableResult
    public func timeSetup(_ prop: Bool?) -> AADebug {
        timeSetup = prop
        return self
    }
}
