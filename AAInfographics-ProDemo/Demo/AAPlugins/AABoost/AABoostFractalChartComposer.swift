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
    private class func boostFractalChart(titleText: String) -> AAOptions {
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
            .text(titleText)
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
        let aaOptions = boostFractalChart(titleText: "Mandelbrot Set") // 更新标题
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateMandelbrotData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue) // Mandelbrot 用方形
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue)
//        }
        return aaOptions
    }
    
    //分形谢尔宾斯基树图
    class func fractalSierpinskiTreeData() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Fractal Canopy Tree") // 更新标题
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiTreeData()
        aaOptions.boost = nil // 树的点可能不多，禁用 boost
        // 树形结构可能需要调整坐标轴范围
        aaOptions.xAxis?.max(800)
        aaOptions.yAxis?.max(800)
        return aaOptions
    }
    
    //分形谢尔宾斯基三角形图
    class func fractalSierpinskiTriangleData() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Sierpinski Triangle") // 更新标题
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiTriangleData()
        seriesElement.marker?.symbol(AAChartSymbolType.triangle.rawValue) // 三角形用三角形标记
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.triangle.rawValue)
//        }
        return aaOptions
    }
    
    //分形谢尔宾斯基地毯图
    class func fractalSierpinskiCarpetData() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Sierpinski Carpet") // 更新标题
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateSierpinskiCarpetData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue) // 地毯用方形标记
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue)
//        }
        return aaOptions
    }
    
    //分形茱莉亚集合图
    class func fractalJuliaSetData() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Julia Set") // 更新标题
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalJuliaSetData.generateJuliaSetData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue) // Julia Set 也常用方形
//         if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue)
//        }
       return aaOptions
    }

    // 新增：巴恩斯利蕨
    class func fractalBarnsleyFern() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Barnsley Fern")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateBarnsleyFernData()
        // 蕨类植物使用小圆点可能效果更好
        seriesElement.marker?.radius(0.5)
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.radius(0.5)
//        }
        // 可能需要调整坐标轴范围以更好地显示蕨类
        aaOptions.xAxis?.min(-300).max(300) // 示例范围，需要根据生成数据调整
        aaOptions.yAxis?.min(0).max(600)   // 示例范围
        aaOptions.chart?.zoomType(.xy) // 蕨类细节多，允许缩放
        return aaOptions
    }

    // 新增：科赫雪花 (点表示)
    class func fractalKochSnowflake() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Koch Snowflake (Points)")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAFractalChartData.generateKochSnowflakeData()
        // 雪花可以用小圆点
        seriesElement.marker?.radius(0.8)
//         if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.radius(0.8)
//        }
       // 可能需要调整坐标轴范围
        aaOptions.xAxis?.min(0).max(800)
        aaOptions.yAxis?.min(100).max(900) // 雪花通常在中间偏上
//        aaOptions.chart?.zoomType(.xy) // 允许缩放
        return aaOptions
    }

    // 新增：龙形曲线
    class func fractalDragonCurve() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Dragon Curve")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAExtraFractalChartData.generateDragonCurveData()
        seriesElement.marker?.radius(0.5) // Small radius for line-like appearance
//        if let scatter = aaOptions.plotOptions?.scatter { // plotOptions might not exist in base func
//            scatter.marker?.radius(0.5)
//        }
        // Reset axes to default 0-800 to see the full extent
        aaOptions.xAxis?.min(0).max(800)
        aaOptions.yAxis?.min(0).max(800)
        aaOptions.chart?.zoomType(.xy) // Ensure zoom is enabled
        aaOptions.boost = nil // Might not need boost, can be re-enabled if slow
        return aaOptions
    }

    // 新增：Levy C 曲线
    class func fractalLevyCCurve() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Levy C Curve")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAExtraFractalChartData.generateLevyCCurveData()
        seriesElement.marker?.radius(0.6)
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.radius(0.6)
//        }
        aaOptions.xAxis?.min(100).max(700)
        aaOptions.yAxis?.min(100).max(700)
//        aaOptions.chart?.zoomType(.xy)
        aaOptions.boost = nil // Might not need boost
        return aaOptions
    }

    // 新增：燃烧船分形
    class func fractalBurningShip() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Burning Ship Fractal")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAExtraFractalChartData.generateBurningShipData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue).radius(1) // Use squares like Mandelbrot
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue).radius(1)
//        }
        // Use default 0-800 axes for pixel mapping
        aaOptions.xAxis?.min(0).max(800)
        aaOptions.yAxis?.min(0).max(800)
//        aaOptions.chart?.zoomType(.xy) // Allow zoom
        // Keep boost enabled for escape time fractals
        return aaOptions
    }

    // 新增：牛顿分形 (z^3 - 1)
    class func fractalNewton() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Newton Fractal (z³ - 1)")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAExtraFractalChartData.generateNewtonFractalData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue).radius(1)
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue).radius(1)
//        }
        aaOptions.xAxis?.min(0).max(800)
        aaOptions.yAxis?.min(0).max(800)
//        aaOptions.chart?.zoomType(.xy)
        // Keep boost enabled
        return aaOptions
    }

    // 新增：Vicsek 分形
    class func fractalVicsek() -> AAOptions {
        let aaOptions = boostFractalChart(titleText: "Vicsek Fractal")
        let seriesElement = aaOptions.series?.first as! AASeriesElement
        seriesElement.data = AAExtraFractalChartData.generateVicsekFractalData()
        seriesElement.marker?.symbol(AAChartSymbolType.square.rawValue).radius(0.8) // Squares fit the theme
//        if let scatter = aaOptions.plotOptions?.scatter {
//            scatter.marker?.symbol(AAChartSymbolType.square.rawValue).radius(0.8)
//        }
        aaOptions.xAxis?.min(0).max(800)
        aaOptions.yAxis?.min(0).max(800)
        aaOptions.chart?.zoomType(.xy)
        aaOptions.boost = nil // Probably not needed
        return aaOptions
    }

} // End of AABoostFractalChartComposer class
