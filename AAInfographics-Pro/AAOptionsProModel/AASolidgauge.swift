//
//  AASolidgauge.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/5.
//

import Foundation

public class AASolidgauge: AAObject {
    public var dataLabels: AADataLabels?
    public var linecap: String?
    public var stickyTracking: Bool?
    public var rounded: Bool?
    
    @discardableResult
    public func dataLabels(_ prop: AADataLabels?) -> AASolidgauge {
        dataLabels = prop
        return self
    }
    
    @discardableResult
    public func linecap(_ prop: String?) -> AASolidgauge {
        linecap = prop
        return self
    }
    
    @discardableResult
    public func stickyTracking(_ prop: Bool?) -> AASolidgauge {
        stickyTracking = prop
        return self
    }
    
    @discardableResult
    public func rounded(_ prop: Bool?) -> AASolidgauge {
        rounded = prop
        return self
    }
    
}


//            .plotOptions(AAPlotOptions()
//                .solidgauge(AASolidgauge()
//                    .dataLabels(AADataLabels()
//                        .enabled(false))
//                    .linecap("round")
//                    .stickyTracking(false)
//                    .rounded(true)))
