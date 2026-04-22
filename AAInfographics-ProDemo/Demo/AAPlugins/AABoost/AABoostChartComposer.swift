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
//                .height("100%")
            )
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
                        .radius(0.8))
                    .tooltip(AATooltip()
                        .followPointer(false)
                        .pointFormat("[{point.x:.1f}, {point.y:.1f}]"))
            ])
        
        return aaOptions
    }

    private static func getSeries(_ n: Int, seriesCount: Int) -> [Any] {
        (0..<seriesCount).map { _ in
            AASeriesElement()
                .data(getData(n))
                .lineWidth(2)
        }
    }

    static func lineChartWithHundredsOfSeries() -> AAOptions {
        let pointCount = 1000
        let seriesCount = 600

        return AAOptions()
            .chart(AAChart()
                .pinchType(.x))
            .title(AATitle()
                .text("Highcharts drawing \(pointCount * seriesCount) points across \(seriesCount) series"))
            .legend(AALegend()
                .enabled(false))
            .boost(AABoost()
                .useGPUTranslations(true))
            .xAxis(AAXAxis()
                .min(0)
                .max(120))
            .subtitle(AASubtitle()
                .text("Using the Boost module"))
            .tooltip(AATooltip()
                .valueDecimals(2))
            .series(getSeries(pointCount, seriesCount: seriesCount))
    }

    static func scatterChartOptions() -> AAOptions {
        let pointCount = 300000
        var data = [[Double]]()
        data.reserveCapacity(pointCount)

        for _ in 0..<pointCount {
            let x = pow(Double.random(in: 0...1), 2) * 100
            let y = pow(Double.random(in: 0...1), 2) * 100
            data.append([x, y])
        }

        return AAOptions()
            .chart(AAChart()
                .pinchType(.xy))
            .boost(AABoost()
                .useGPUTranslations(true)
                .usePreallocated(true))
            .title(AATitle()
                .text("Scatter chart with \(pointCount) points"))
            .legend(AALegend()
                .enabled(false))
            .series([
                AASeriesElement()
                    .type(.scatter)
                    .color("rgb(152, 0, 67)")
                    .fillOpacity(0.1)
                    .data(data)
                    .marker(AAMarker()
                        .radius(1))
                    .tooltip(AATooltip()
                        .followPointer(false)
                        .pointFormat("[{point.x:.1f}, {point.y:.1f}]"))
            ])
    }

    private static func getAreaRangeChartData(_ count: Int) -> [[Double]] {
        var arr = [[Double]]()
        arr.reserveCapacity(count)

        var a = 0.0
        var b = 0.0
        var c = 0.0

        for i in 0..<count {
            if i % 100 == 0 {
                a = 2 * Double.random(in: 0...1)
            }
            if i % 1000 == 0 {
                b = 2 * Double.random(in: 0...1)
            }
            if i % 10000 == 0 {
                c = 2 * Double.random(in: 0...1)
            }

            let spike = i % 50000 == 0 ? 10.0 : 0.0
            let low = 2 * sin(Double(i) / 100.0) + a + b + c + spike + Double.random(in: 0...1)
            let high = low + 5 + 5 * Double.random(in: 0...1)
            arr.append([Double(i), low, high])
        }

        return arr
    }

    static func areaRangeChart() -> AAOptions {
        let pointCount = 500000

        return AAOptions()
            .chart(AAChart()
                .type(.arearange)
                .pinchType(.x)
                .panning(true)
                .panKey("shift"))
            .boost(AABoost()
                .useGPUTranslations(true))
            .title(AATitle()
                .text("Highcharts drawing \(pointCount) points"))
            .xAxis(AAXAxis()
                .crosshair(AACrosshair()
                    .color(AAColor.green)))
            .subtitle(AASubtitle()
                .text("Using the Boost module"))
            .tooltip(AATooltip()
                .valueDecimals(2))
            .colors([AAColor.red])
            .series([
                AASeriesElement()
                    .data(getAreaRangeChartData(pointCount))
            ])
    }

    static func columnRangeChart() -> AAOptions {
        let aaOptions = areaRangeChart()
        aaOptions.chart?.type(.columnrange)
        aaOptions.colors = [AAColor.yellow]
        return aaOptions
    }

    private static func getBubbleChartData(_ count: Int) -> [[Double]] {
        var arr = [[Double]]()
        arr.reserveCapacity(count)

        for _ in 0..<count {
            arr.append([
                pow(Double.random(in: 0...1), 2) * 100,
                pow(Double.random(in: 0...1), 2) * 100,
                pow(Double.random(in: 0...1), 2) * 100
            ])
        }

        return arr
    }

    static func bubbleChart() -> AAOptions {
        let pointCount = 50000

        return AAOptions()
            .chart(AAChart()
                .type(.bubble)
                .pinchType(.xy))
            .xAxis(AAXAxis()
                .gridLineWidth(1)
                .minPadding(0)
                .maxPadding(0)
                .startOnTick(false)
                .endOnTick(false))
            .yAxis(AAYAxis()
                .minPadding(0)
                .maxPadding(0)
                .startOnTick(false)
                .endOnTick(false))
            .title(AATitle()
                .text("Bubble chart with \(pointCount) points"))
            .legend(AALegend()
                .enabled(false))
            .boost(AABoost()
                .useGPUTranslations(true)
                .usePreallocated(true))
            .plotOptions(AAPlotOptions()
                .bubble(AABubble()
                    .minSize(1)
                    .maxSize(10)))
            .series([
                AASeriesElement()
                    .type(.bubble)
                    .color("rgb(152, 0, 67)")
                    .fillOpacity(0.1)
                    .data(getBubbleChartData(pointCount))
                    .tooltip(AATooltip()
                        .followPointer(false)
                        .pointFormat("[{point.x:.1f}, {point.y:.1f}]"))
            ])
    }

    static func heatMapChart() -> AAOptions {
        let aaOptions = AAHeatOrTreeMapChartComposer.largeDataHeatmapChart()
        aaOptions.boost(AABoost()
            .useGPUTranslations(true))
        return aaOptions
    }

    static func stackingAreaChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.area)
                .pinchType(.x))
            .boost(AABoost()
                .useGPUTranslations(true))
            .title(AATitle()
                .text("Highcharts drawing 50000 points"))
            .subtitle(AASubtitle()
                .text("Using the Boost module"))
            .tooltip(AATooltip()
                .valueDecimals(2))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .stacking(.percent)))
            .colors([
                AAColor.red,
                AAColor.yellow
            ])
            .series([
                AASeriesElement()
                    .data(getData(25000)),
                AASeriesElement()
                    .data(getData(25000))
            ])
    }

    static func stackingColumnChart() -> AAOptions {
        let aaOptions = stackingAreaChart()
        aaOptions.chart?.type(.column)
        aaOptions.colors = [
            AAColor.green,
            AAColor.purple
        ]
        return aaOptions
    }
    
}


