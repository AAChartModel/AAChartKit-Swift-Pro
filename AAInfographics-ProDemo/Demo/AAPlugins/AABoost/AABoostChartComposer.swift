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
    
    /**
     // Prepare the data

     const data = [],
         n = 1000000;

     // Generate and position the datapoints in a tangent wave pattern
     for (let i = 0; i < n; i += 1) {
         const theta = Math.random() * 2 * Math.PI;
         const radius = Math.pow(Math.random(), 2) * 100;

         const waveDeviation = (Math.random() - 0.5) * 70;
         const waveValue = Math.tan(theta) * waveDeviation;

         data.push([
             50 + (radius + waveValue) * Math.cos(theta),
             50 + (radius + waveValue) * Math.sin(theta)
         ]);
     }

     if (!Highcharts.Series.prototype.renderCanvas) {
         throw 'Module not loaded';
     }

     console.time('scatter');
     Highcharts.chart('container', {

         chart: {
             zooming: {
                 type: 'xy'
             },
             height: '100%'
         },

         boost: {
             useGPUTranslations: true,
             usePreAllocated: true
         },

         accessibility: {
             screenReaderSection: {
                 beforeChartFormat: '<{headingTagName}>' +
                     '{chartTitle}</{headingTagName}><div>{chartLongdesc}</div>' +
                     '<div>{xAxisDescription}</div><div>{yAxisDescription}</div>'
             }
         },

         xAxis: {
             min: 0,
             max: 100,
             gridLineWidth: 1
         },

         yAxis: {
             // Renders faster when we don't have to compute min and max
             min: 0,
             max: 100,
             minPadding: 0,
             maxPadding: 0,
             title: {
                 text: null
             }
         },

         title: {
             text: 'Scatter chart with 1 million points',
             align: 'left'
         },

         legend: {
             enabled: false
         },

         series: [{
             type: 'scatter',
             color: 'rgba(152,0,67,0.1)',
             data: data,
             marker: {
                 radius: 0.5
             },
             tooltip: {
                 followPointer: false,
                 pointFormat: '[{point.x:.1f}, {point.y:.1f}]'
             }
         }]

     });
     console.timeEnd('scatter');

     */
    static func scatterChartWith1MillionPoints() -> AAOptions {
        // Prepare the data
        
        let n = 1000000
        var data: [[Double]] = []
        
        // Generate and position the datapoints in a tangent wave pattern
        for _ in 0..<n {
            let theta = Double(arc4random_uniform(1000000)) / 1000000.0 * 2 * Double.pi
            let radius = pow(Double(arc4random_uniform(1000000)) / 1000000.0, 2) * 100
            let waveDeviation = (Double(arc4random_uniform(1000000)) / 1000000.0 - 0.5) * 70
            let waveValue = tan(theta) * waveDeviation
            data.append([
                50 + (radius + waveValue) * cos(theta),
                50 + (radius + waveValue) * sin(theta)
            ])
        }
        
        let aaOptions = AAOptions()
            .boost(AABoost()
                .useGPUTranslations(true)
                .usePreallocated(true))
            .chart(AAChart()
                .zoomType(.xy)
                .height("100%"))
            .xAxis(AAXAxis()
                .min(0)
                .max(100)
                .gridLineWidth(1))
            .yAxis(AAYAxis()
                .min(0)
                .max(100)
                .minPadding(0)
                .maxPadding(0)
                .title(AATitle()
                    .text(nil)))
            .title(AATitle()
                .text("Scatter chart with 1 million points")
                .align(.left))
            .legend(AALegend()
                .enabled(false))
            .series([
                AASeriesElement()
                    .type(.scatter)
                    .color("rgba(152,0,67,0.1)")
                    .data(data)
                    .marker(AAMarker()
                        .radius(0.5))
                    .tooltip(AATooltip()
                        .followPointer(false)
                        .pointFormat("[{point.x:.1f}, {point.y:.1f}]"))
            ])
        
        return aaOptions
    }
    
}



