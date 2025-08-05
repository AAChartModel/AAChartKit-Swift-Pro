//
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AAColumnVariantChartComposer {
    
    static func variwideChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.variwide)
        
        let aaTitle = AATitle()
            .text("2016 年欧洲各国人工成本")
        
        let aaSubtitle = AASubtitle()
            .text("数据来源:EUROSTAT")
        
        let aaXAxis = AAXAxis()
            .visible(true)
            .type(.category)
            .title(AATitle()
                .text("* 柱子宽度与 GDP 成正比"))
        
        let aaTooltip = AATooltip()
            .enabled(true)
            .pointFormat("人工成本： <b>€ {point.y}/h</b><br>' + 'GDP: <b>€ {point.z} 百万</b><br>")
        
        let aaLegend = AALegend()
            .enabled(false)
        
        let seriesElementArr = [
            AASeriesElement()
                .name("人工成本")
                .data(AAOptionsData.variwideData)
                .dataLabels(AADataLabels()
                    .enabled(true)
                    .format("€{point.y:.0f}"))
                .colorByPoint((true))]
        
        return AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
    }
    
    static func columnpyramidChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.columnpyramid))
            .title(AATitle()
                .text("世界 5 大金字塔"))
            .xAxis(AAXAxis()
                .visible(true)
                .type(.category))
            .yAxis(AAYAxis()
                .visible(true)
                .title(AATitle()
                    .text("高度 (m)")))
            .tooltip(AATooltip()
                .enabled(true)
                .valueSuffix(" m"))
            .series([
                AASeriesElement()
                    .name("Height")
                    .colorByPoint(true)
                    .data(AAOptionsData.columnpyramidData)
            ])
    }
    
    static func dumbbellChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.dumbbell)
            .inverted(true)
        
        let aaTitle = AATitle()
            .text("各国预期寿命变化")
        
        let aaSubtitle = AASubtitle()
            .text("1960 vs 2018")
        
        let aaXAxis = AAXAxis()
            .visible(true)
            .type(.category)
        
        let aaYAxis = AAYAxis()
            .visible(true)
            .title(AATitle()
                .text("Life Expectancy (years)"))
        
        let aaTooltip = AATooltip()
            .enabled(true)
        
        let aaLegend = AALegend()
            .enabled(false)
        
        let seriesElementArr = [
            AASeriesElement()
                .name("各国预期寿命变化")
                .data(AAOptionsData.dumbbellData)
        ]
        
        return AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .yAxis(aaYAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
    }
    
    static func lollipopChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.lollipop)
        
        let aaTitle = AATitle()
            .text("世界十大人口国家")
        
        let aaSubtitle = AASubtitle()
            .text("2018")
        
        let aaXAxis = AAXAxis()
            .visible(true)
            .type(.category)
        
        let aaYAxis = AAYAxis()
            .visible(true)
            .title(AATitle()
                .text("人口"))
        
        let aaTooltip = AATooltip()
            .enabled(true)
        
        let aaLegend = AALegend()
            .enabled(false)
        
        let seriesElementArr = [
            AASeriesElement()
                .name("Population")
                .data(AAOptionsData.lollipopData)
        ]
        
        return AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .yAxis(aaYAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
    }
    
    static func xrangeChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.xrange))
            .colors([
                "#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9",
                "rgb(255,143,179)","rgb(255,117,153)",
                "#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1","#7cb5ec","#434348","#f7a35c",
                "rgb(119,212,100)","rgb(93,186,74)","rgb(68,161,49)"
            ])
            .title(AATitle()
                .text(""))
            .yAxis(AAYAxis()
                .visible(true)
                .title(AATitle()
                    .text(""))
                .reversed(true)
                .categories(["原型","开发","测试","上线"])
                .gridLineWidth(0))
            .legend(AALegend()
                .enabled(false))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .pointPadding(0)
                    .groupPadding(0)))
            .series([
                AASeriesElement()
                    .borderRadius(2)
                    .data(AAOptionsData.xrangeData)
            ])
    }
    
    static func invertedXrangeChart() -> AAOptions {
        let aaOptions = xrangeChart()
        
        aaOptions.colors([])
        aaOptions.chart?.inverted(true)
        //离离原上草, 一岁一枯荣
        //野火烧不尽, 春风吹又生
        aaOptions.yAxis?.categories([
            "离", "离", "原", "上", "草",
            "一", "岁", "一", "枯", "荣",
            "野", "火", "烧", "不", "尽",
            "春", "风", "吹", "又", "生"
            ])
        aaOptions.plotOptions?.series?.groupPadding(0.1)
        aaOptions.series([
            AASeriesElement()
                .borderRadius(2)
                .data(AAOptionsData.xrange2Data)
        ])
        
        return aaOptions
    }
    
    static func histogramChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("Highcharts Histogram"))
            .xAxisArray([
                AAXAxis()
                    .title(AATitle()
                        .text("Data")),
                AAXAxis()
                    .title(AATitle()
                        .text("Histogram"))
                    .opposite(true)
            ])
            .yAxisArray([
                AAYAxis()
                    .title(AATitle()
                        .text("Data")),
                AAYAxis()
                    .title(AATitle()
                        .text("Histogram"))
                    .opposite(true)
            ])
            .series([
                AASeriesElement()
                    .name("Histogram")
                    .type(.histogram)
                    .xAxis(1)
                    .yAxis(1)
                    .baseSeries("s1")
                    .zIndex(-1),
                AASeriesElement()
                    .name("Data")
                    .type(.scatter)
                    .data((AAOptionsData.bellcurveData))
                    .id("s1")
                    .marker(AAMarker()
                        .fillColor(AAColor.white)//点的填充色(用来设置折线连接点的填充色)
                        .lineWidth(2)//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
                        .lineColor(""))//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色))
            ])
    }
    
    static func bellcurveChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("Bell curve"))
            .xAxisArray([
                AAXAxis()
                    .title(AATitle()
                        .text("Data")),
                AAXAxis()
                    .title(AATitle()
                        .text("Bell curve")),
            ])
            .yAxisArray([
                AAYAxis()
                    .title(AATitle()
                        .text("Data")),
                AAYAxis()
                    .title(AATitle()
                        .text("Bell curve")),
            ])
            .series([
                AASeriesElement()
                    .name("Bell curve")
                    .type(.bellcurve)
                    .xAxis(1)
                    .yAxis(1)
                    .baseSeries(1)
                    .zIndex(-1)
                ,
                AASeriesElement()
                    .name("Data")
                    .type(.scatter)
                    .marker(AAMarker()
                        .fillColor(AAColor.white)//点的填充色(用来设置折线连接点的填充色)
                        .lineWidth(2)//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
                        .lineColor(""))//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色))
                    .data(AAOptionsData.bellcurveData)
            ])
    }
    
    static func bulletChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .marginTop(100)
                .inverted(true)
                   //                .marginLeft(135)
                .height(200)
                .type(.bullet))
            .title(AATitle()
                .text("2017 年公司运营情况"))
            .xAxis(AAXAxis()
                .categories(["<span style=color:#ff0000;font-weight:bold;font-size:13px>营收</span><br/>千美元"]))
            .yAxis(AAYAxis()
                .gridLineWidth(0)
                .plotBands([
                    AAPlotBandsElement()
                        .from(0)
                        .to(150)
                        .color("#666"),
                    AAPlotBandsElement()
                        .from(150)
                        .to(225)
                        .color("#999"),
                    AAPlotBandsElement()
                        .from(225)
                        .to(9000000000)
                        .color("#bbb")
                ])
                    .title(AATitle().text("")))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .pointPadding(0.25)
                    .borderWidth(0)
                        //                    .color("#000")
                        //                    .targetOptions(AATargetOptions()
                        //                        .width("200%"))
                ))
            .legend(AALegend()
                .enabled(false))
            .series([
                AASeriesElement()
                    .color("#000")
                    .data([
                        AABulletDataElement()
                            .y(275)
                            .target(250)
                    ])
            ])
            .tooltip(AATooltip()
                .pointFormat("{point.y} （目标值 {point.target}）"))
    }
    
    
    
}
