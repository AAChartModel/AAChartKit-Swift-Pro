//
//  AABoostFractalChartComposer.swift
//  AAChartKit-ProDemo
//
//  Created by AnAn on 2025/4/9.
//  Copyright © 2025 An An. All rights reserved.
//

import Foundation

class AABoostFractalChartComposer {

    /**
     Highcharts.chart('container', {
         chart: {
             type: 'scatter',
             zoomType: 'xy',
             boost: {
                 useGPUTranslations: true,
                 usePreallocated: true,
                 seriesThreshold: 1
             },
             backgroundColor: 'transparent', // 透明背景
             renderTo: 'container'
         },
         title: {
             text: 'Colorful Sierpinski Carpet', // 更新标题
             style: {
                 color: '#e0f0ff',
                 fontSize: '24px',
                 textShadow: '0 0 5px #ffffff'
              }
         },
         // 设置坐标轴范围以匹配画布大小
         xAxis: { min: 0, max: 800, visible: false, startOnTick: false, endOnTick: false },
         yAxis: { min: 0, max: 800, visible: false, startOnTick: false, endOnTick: false },
         legend: { enabled: false },
         plotOptions: {
             scatter: {
                 marker: {
                     radius: 1, // 根据 maxDepth 和点密度调整
                     symbol: 'square' // 方形标记更符合地毯主题
                 },
                 tooltip: { enabled: false },
                 boostThreshold: 1,
                 states: {
                     hover: { enabled: false },
                     inactive: { enabled: false }
                 }
             }
         },
         series: [{
             name: 'Carpet',
             data: generateSierpinskiData(),
             // animation: false // 可选：禁用动画
         }],
         credits: { enabled: false }
     });

     */
    private class func boostFractalChart() -> AAOptions {
        // 配置 AAChartKit 图表选项
        let chart = AAChart()
            .type(.scatter)
//            .zoomType(.xy)
            .backgroundColor(AAColor.black)
//            .boost(AABoost()
//                .useGPUTranslations(true)
//                .usePreallocated(true)
//                .seriesThreshold(1))
        
        let boost = AABoost()
            .useGPUTranslations(true)
            .usePreallocated(true)
            .seriesThreshold(1)
        
        let title = AATitle()
            .text("Colorful Sierpinski Carpet")
            .style(AAStyle()
                .color("#e0f0ff")
//                .fontSize("24px")
                .textOutline("0 0 5px #ffffff"))
        
        let xAxis = AAXAxis()
            .min(0)
            .max(800)
            .visible(false)
            .startOnTick(false)
            .endOnTick(false)
        
        let yAxis = AAYAxis()
            .min(0)
            .max(800)
            .visible(false)
            .startOnTick(false)
            .endOnTick(false)
        
        let seriesElement = AASeriesElement()
            .name("Carpet")
//            .data(AAFractalChartData.generateSierpinskiTriangleData())
            .marker(AAMarker()
                .radius(1)
                .symbol(AAChartSymbolType.square.rawValue)
            )
        
        let options = AAOptions()
            .chart(chart)
            .boost(boost)
            .title(title)
            .xAxis(xAxis)
            .yAxis(yAxis)
            .series([seriesElement])
            .credits(AACredits().enabled(false))
        
        return options
    }
    
    //分形曼德尔布罗特图
    class func fractalMandelbrot() -> AAOptions {
        let aaOptions = boostFractalChart()
        let seriesElement = aaOptions.series?.first as!AASeriesElement
        seriesElement.data = AAFractalChartData.generateMandelbrotData()
        return aaOptions
    }
    
    //分形谢尔宾斯基树图
    class func fractalSierpinskiTreeData() -> AAOptions {
        let aaOptions = boostFractalChart()
        let seriesElement = aaOptions.series?.first as!AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiTreeData()
        aaOptions.boost = nil
        return aaOptions
    }
    
    //分形谢尔宾斯基三角形图
    class func fractalSierpinskiTriangleData() -> AAOptions {
        let aaOptions = boostFractalChart()
        let seriesElement = aaOptions.series?.first as!AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiTriangleData()
        return aaOptions
    }
    
    //分形谢尔宾斯基地毯图
    class func fractalSierpinskiCarpetData() -> AAOptions {
        let aaOptions = boostFractalChart()
        let seriesElement = aaOptions.series?.first as!AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiCarpetData()
        return aaOptions
    }
}
