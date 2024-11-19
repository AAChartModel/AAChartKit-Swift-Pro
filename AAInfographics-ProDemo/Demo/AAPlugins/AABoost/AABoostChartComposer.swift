//
//  File.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/11/18.
//

import Foundation

public class AABoostChartComposer {
    
    //配置 AAOptions 实例对象
    static func getData(_ n: Int) -> [[Double]] {
        var arr: [[Double]] = []
        var a = 0.0, b = 0.0, c = 0.0, spike: Double
        
        for i in 0..<n {
            if i % 100 == 0 {
                a = 2 * Double(arc4random_uniform(1000000)) / 1000000.0
            }
            if i % 1000 == 0 {
                b = 2 * Double(arc4random_uniform(1000000)) / 1000000.0
            }
            if i % 10000 == 0 {
                c = 2 * Double(arc4random_uniform(1000000)) / 1000000.0
            }
            if i % 50000 == 0 {
                spike = 10
            } else {
                spike = 0
            }
            
            let value = 2 * sin(Double(i) / 100.0) + a + b + c + spike + (Double(arc4random_uniform(1000000)) / 1000000.0)
            arr.append([Double(i), value])
        }
        
        return arr
    }
    
    static func lineChart() -> AAOptions {
        let n = 500000
        let data = getData(n)
        
        let aaOptions = AAOptions()
            .boost(AABoost()
                .useGPUTranslations(true))
            .chart(AAChart()
                .pinchType(.x)
                .panning(true)
                .panKey("shift"))
            .colors([AAColor.red])
            .title(AATitle()
                .text("Highcharts drawing \(n) points"))
            .subtitle(AASubtitle()
                .text("Using the Boost module"))
            .tooltip(AATooltip()
                .valueDecimals(2))
            .series([
                AASeriesElement()
                    .data(data)
                    .lineWidth(0.5)
            ])
        
        return aaOptions
    }
    
    static func areaChart() -> AAOptions {
        let aaOptions = lineChart()
        aaOptions.chart?.type(.area)
        aaOptions.colors = [AAColor.green]
        return aaOptions
    }
    
    static func columnChart() -> AAOptions {
        let aaOptions = lineChart()
        aaOptions.chart?.type(.column)
        aaOptions.colors = [AAColor.blue]
        return aaOptions
    }
    
    
}



