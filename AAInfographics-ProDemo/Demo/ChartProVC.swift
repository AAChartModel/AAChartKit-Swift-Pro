//
//  ChartProVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

class ChartProVC: AABaseChartVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch selectedIndex {
        case  1: return variablepieChart()
        case  2: return treemapWithLevelsData()
        case  3: return variwideChart()
        case  4: return sunburstChart()
        case  5: return dependencywheelChart()
        case  6: return heatmapChart()
        case  7: return packedbubbleChart()
        case  8: return packedbubbleSplitChart()
        case  9: return vennChart()
        case 10: return dumbbellChart()
        case 11: return lollipopChart()
        case 12: return streamgraphChart()
        case 13: return columnpyramidChart()
        case 14: return tilemapChart()
        case 15: return treemapWithColorAxisData()
        case 16: return drilldownTreemapChart()
        case 17: return xrangeChart()
        case 18: return vectorChart()
        case 19: return bellcurveChart()
        case 20: return timelineChart()
        case 21: return itemChart()
        case 22: return windbarbChart()
        case 23: return networkgraphChart()
        case 24: return wordcloudChart()
        case 25: return eulerChart()
        case 26: return organizationChart()
        case 27: return arcdiagramChart1()
        case 28: return arcdiagramChart2()
        case 29: return arcdiagramChart3()
        case 30: return flameChart()
        case 31: return packedbubbleSpiralChart()
        case 32: return itemChart2()
        case 33: return itemChart3()
        case 34: return icicleChart()
        case 35: return sunburstChart2()
        case 36: return generalDrawingChart()
        case 37: return solidgaugeChart()

            
        default:
            return sankeyChart()
        }
    }
    
        
    private func sankeyChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                    .text("AAChartKit-Pro 桑基图"))
            .colors([
                AARgba(137, 78, 36),
                AARgba(220, 36, 30),
                AARgba(255, 206, 0),
                AARgba(1, 114, 41),
                AARgba(0, 175, 173),
                AARgba(215, 153, 175),
                AARgba(106, 114, 120),
                AARgba(114, 17, 84),
                AARgba(0, 0, 0),
                AARgba(0, 24, 168),
                AARgba(0, 160, 226),
                AARgba(106, 187, 170)
            ])
            .series([
                AASeriesElement()
                    .type(.sankey)
                    .keys(["from", "to", "weight"])
                    .data(AAOptionsData.sankeyData),
            ])
    }
    
    private func variablepieChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.variablepie)
        
        let aaTitle = AATitle()
            .text("不同国家人口密度及面积对比")
        
        let aaSubtitle = AASubtitle()
            .text("扇区长度（圆周方法）表示面积，宽度（纵向）表示人口密度")
        
        let aaTooltip = AATooltip()
            .enabled(true)
            .headerFormat("")
            .pointFormat(#"<span style="color:{point.color}\">○</span> <b> {point.name}</b><br/>"面积 (平方千米): <b>{point.y}</b><br/>"人口密度 (每平方千米人数): <b>{point.z}</b><br/>""#.aa_toPureJSString())
        
        return AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .tooltip(aaTooltip)
            .series([
                AASeriesElement()
                    .name("countries")
                    .innerSize("20%")
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .data(AAOptionsData.variablepieData)
            ])
    }
    
    private func treemapWithLevelsData() -> AAOptions {
        AAOptions()
            .title(AATitle()
                    .text("Fruit Consumption Situation"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AASeriesElement()
                    .type(.treemap)
                    .levels([
                        AALevelsElement()
                            .level(1)
                            .layoutAlgorithm("sliceAndDice")
                            .dataLabels(AADataLabels()
                                            .enabled(true)
                                            .align(.left)
                                            .verticalAlign(.top)
                                            .style(AAStyle()
                                                    .fontSize(15)
                                                    .fontWeight(.bold)))
                    ])
                    .data(AAOptionsData.treemapWithLevelsData)
            ])
    }
    
    private func variwideChart() -> AAOptions {
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
    
    private func sunburstChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.sunburst)
        
        let aaTitle = AATitle()
            .text("2017 世界人口分布")
        
        let aaSubtitle = AASubtitle()
            .text(#"数据来源:<href="https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)">Wikipedia</a>"#.aa_toPureJSString())
        
        let aaTooltip = AATooltip()
            .enabled(true)
            .pointFormat("<b>{point.name}</b>的人口数量是：<b>{point.value}</b>")
        
        let aaLegend = AALegend()
            .enabled(false)
        
        let seriesElementArr = [
            AASeriesElement()
                .allowDrillToNode(true)
                .levels([
                    AALevelsElement()
                        .level(2)
                        .colorByPoint(true)
                        .layoutAlgorithm("sliceAndDice")
                    ,
                    AALevelsElement()
                        .level(3)
                        .colorVariation(AAColorVariation()
                                            .key("brightness")
                                            .to(-0.5))
                    ,
                    AALevelsElement()
                        .level(4)
                        .colorVariation(AAColorVariation()
                                            .key("brightness")
                                            .to(0.5))
                    
                ])
                .data(AAOptionsData.sunburstData)
        ]
        
        return AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
    }
    
    private func dependencywheelChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .marginLeft(20)
                    .marginRight(20))
            .title(AATitle()
                    .text("AAChartKit-Pro 和弦图"))
            .series([
                AASeriesElement()
                    .type(.dependencywheel)
                    .name("Dependency wheel series")
                    .keys(["from","to","weight"])
                    .data(AAOptionsData.dependencywheelData)
                    .dataLabels(AADataLabels()
                                    .enabled(true)
                                    .color("#333")
                                    .textPath(AATextPath()
                                                .enabled(true)
                                                .attributes([
                                                    "dy": 5
                                                ]))
                                    .distance(10))
            ])
    }
    
    
    // https://jshare.com.cn/demos/hhhhiz
    private func heatmapChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.heatmap))
            .title(AATitle()
                    .text("Sales per employee per weekday"))
            .xAxis(AAXAxis()
                    .visible(true)
                    .categories([
                        "Alexander", "Marie", "Maximilian", "Sophia",
                        "Lukas", "Maria", "Leon", "Anna", "Tim", "Laura"
                    ]))
            .yAxis(AAYAxis()
                    .visible(true)
                    .categories(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
                    .title(AATitle()
                            .text("")))
            .colorAxis(AAColorAxis()
                        .min(0)
                        .minColor(AAColor.white)
                        .maxColor("#7cb5ec"))
            .legend(AALegend()
                        .enabled(true)
                        .align(.right)
                        .layout(.vertical)
                        .verticalAlign(.top)
                        .y(25))
            .tooltip(AATooltip()
                        .enabled(true)
                        .formatter("""
                    function () {
                    return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> sold <br><b>' +
                        this.point.value + '</b> items on <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>'
                    }
                    """))
            .series([
                AASeriesElement()
                    .name("Sales")
                    .borderWidth(1)
                    .data(AAOptionsData.heatmapData)
                    .dataLabels(AADataLabels()
                                    .enabled(true)
                                    .color(AAColor.red))
            ])
    }
    
    
    // https://www.highcharts.com.cn/demo/highcharts/packed-bubble
    private func packedbubbleChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.packedbubble))
            .title(AATitle()
                    .text("2014 年世界各地碳排放量"))
            .tooltip(AATooltip()
                        .enabled(true)
                        .useHTML(true)
                        .pointFormat("<b>{point.name}:</b> {point.y}m CO<sub>2</sub>"))
            .plotOptions(AAPlotOptions()
                            .packedbubble(AAPackedbubble()
                                            .minSize("30%")
                                            .maxSize("120%")
                                            .zMin(0)
                                            .zMax(1000)
                                            .layoutAlgorithm(AALayoutAlgorithm() //packedbubbleChart 和 packedbubbleSplitChart 只有layoutAlgorithm这一段不一样
                                                                .gravitationalConstant(0.02)
                                                                .splitSeries(false)
                                            )
                                            .dataLabels(AADataLabels()
                                                            .enabled(true)
                                                            .format("{point.name}")
                                                            .filter(AAFilter()
                                                                        .property("y")
                                                                        .operator(">")
                                                                        .value(250)))))
            .series(AAOptionsSeries.packedbubbleSeries)
    }
    
    // https://www.highcharts.com.cn/demo/highcharts/packed-bubble-split
    private func packedbubbleSplitChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.packedbubble))
            .title(AATitle()
                    .text("2014 年世界各地碳排放量"))
            .tooltip(AATooltip()
                        .enabled(true)
                        .useHTML(true)
                        .pointFormat("<b>{point.name}:</b> {point.y}m CO<sub>2</sub>"))
            .plotOptions(AAPlotOptions()
                            .packedbubble(AAPackedbubble()
                                            .minSize("30%")
                                            .maxSize("120%")
                                            .zMin(0)
                                            .zMax(1000)
                                            .layoutAlgorithm(AALayoutAlgorithm() //packedbubbleChart 和 packedbubbleSplitChart 只有layoutAlgorithm这一段不一样
                                                                .gravitationalConstant(0.05)
                                                                .splitSeries(true)
                                                                .seriesInteraction(false)
                                                                .dragBetweenSeries(true)
                                                                .parentNodeLimit(true))
                                            .dataLabels(AADataLabels()
                                                            .enabled(true)
                                                            .format("{point.name}")
                                                            .filter(AAFilter()
                                                                        .property("y")
                                                                        .operator(">")
                                                                        .value(250)))))
            .series(AAOptionsSeries.packedbubbleSeries)
    }
    
    
    private func vennChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                    .text("The Unattainable Triangle"))
            .series([
                AASeriesElement()
                    .type(.venn)
                    .data(AAOptionsData.vennData)
            ])
    }
    
    private func dumbbellChart() -> AAOptions {
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
    
    private func lollipopChart() -> AAOptions {
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
    
    private func streamgraphChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.streamgraph))
            .colors([
                "#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9",
                "rgb(255,143,179)","rgb(255,117,153)",
                "#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1","#7cb5ec","#434348","#f7a35c",
                "rgb(119,212,100)","rgb(93,186,74)","rgb(68,161,49)"
            ])
            .title(AATitle()
                    .text("冬季奥运会奖牌分布"))
            .subtitle(AASubtitle()
                        .text("1924-2014"))
            .xAxis(AAXAxis()
                    .visible(true)
                    .type(.category)
                    .categories([
                        "", "1924", "1928", "1932", "1936", "1940", "1944", "1948", "1952", "1956", "1960",
                        "1964", "1968", "1972", "1976", "1980", "1984", "1988", "1992", "1994", "1998",
                        "2002", "2006", "2010", "2014"
                    ]))
            .yAxis(AAYAxis()
                    .visible(false))
            .tooltip(AATooltip()
                        .enabled(true))
            .legend(AALegend()
                        .enabled(false))
            .series(AAOptionsSeries.streamgraphSeries)
    }
    
    private func columnpyramidChart() -> AAOptions {
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
    
    private func tilemapChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.tilemap))
            .title(AATitle()
                    .text("U.S. states by population in 2016"))
            .xAxis(AAXAxis()
                    .visible(false))
            .yAxis(AAYAxis()
                    .visible(false))
            .colorAxis(AAColorAxis()
                        .dataClasses([
                            AADataClassesElement()
                                .from(0)
                                .to(1000000)
                                .color("#F9EDB3")
                                .name("< 1M"),
                            AADataClassesElement()
                                .from(1000000)
                                .to(5000000)
                                .color("#FFC428")
                                .name("1M - 5M"),
                            AADataClassesElement()
                                .from(5000000)
                                .to(20000000)
                                .color("#F9EDB3")
                                .name("5M - 20M"),
                            AADataClassesElement()
                                .from(20000000)
                                .color("#FF2371")
                                .name("> 20M"),
                        ]))
            .tooltip(AATooltip()
                        .enabled(true)
                        .headerFormat("")
                        .valueSuffix("The population of <b> {point.name}</b> is <b>{point.value}</b>"))
            .plotOptions(AAPlotOptions()
                            .series(AASeries()
                                        .dataLabels(AADataLabels()
                                                        .enabled(true)
                                                        .format("{point.hc-a2}")
                                                        .color(AAColor.white)
                                                        .style(AAStyle()
                                                                .textOutline("none")))))
            .series([
                AASeriesElement()
                    .name("Height")
                    .colorByPoint(true)
                    .data(AAOptionsData.tilemapData)
            ])
    }
    
    private func treemapWithColorAxisData() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.treemap))
            .title(AATitle()
                    .text("矩形树图"))
            .colorAxis(AAColorAxis()
                        .minColor(AAColor.white)
                        .maxColor(AAColor.red))
            .series([
                AASeriesElement()
                    .data(AAOptionsData.treemapWithColorAxisData)
            ])
    }
    
    private func drilldownTreemapChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.treemap))
            .title(AATitle()
                    .text("2012年，全球每10w人口死亡率"))
            .subtitle(AASubtitle()
                        .text("点击下钻"))
            .plotOptions(AAPlotOptions()
                            .treemap(AATreemap()
                                        .allowTraversingTree(true)
                                        .layoutAlgorithm("squarified")))
            .series([
                AASeriesElement()
                    .type(.treemap)
                    .levels([
                        AALevelsElement()
                            .level(1)
                            .dataLabels(AADataLabels()
                                            .enabled(true))
                            .borderWidth(3)
                    ])
                    .data(AAOptionsData.drilldownTreemapData)
            ])
    }
    
    private func xrangeChart() -> AAOptions {
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
    
    private func vectorChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.vector))
            .colors(["red"])
            .title(AATitle()
                    .text("AAChartKit-Pro Vector plot"))
            .series([
                AASeriesElement()
                    .name("Sample vector field")
                    .data(AAOptionsData.vectorData)
            ])
    }
    
    private func bellcurveChart() -> AAOptions {
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
    
    private func timelineChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.timeline))
            .title(AATitle()
                    .text("人类太空探索时间表"))
            .subtitle(AASubtitle()
                        .text("数据来源: https://en.wikipedia.org/wiki/Timeline_of_space_exploration"))
            .yAxis(AAYAxis()
                    .visible(false))
            .series([
                AASeriesElement()
                    .data(AAOptionsData.timelineData)
            ])
    }
    
    private func itemChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.item))
            .title(AATitle()
                    .text("AAChartKit-Pro item chart"))
            .subtitle(AASubtitle()
                        .text("Parliament visualization"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AAItem()
                    .name("Representatives")
                    .keys(["name","y","color","label"])
                    .data(AAOptionsData.itemData)
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .startAngle(-100)
                    .endAngle(+100)
            ])
    }
    
    private func itemChart2() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.item))
            .title(AATitle()
                    .text("AAChartKit-Pro item chart"))
            .subtitle(AASubtitle()
                        .text("Parliament visualization"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AAItem()
                    .name("Representatives")
                    .keys(["name","y","color","label"])
                    .data(AAOptionsData.itemData)
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .startAngle(nil)
                    .endAngle(nil)
            ])
    }
    
    private func itemChart3() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.item))
            .title(AATitle()
                    .text("AAChartKit-Pro item chart"))
            .subtitle(AASubtitle()
                        .text("Parliament visualization"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AAItem()
                    .name("Representatives")
                    .keys(["name","y","color","label"])
                    .data(AAOptionsData.itemData)
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .startAngle(0)
                    .endAngle(360)
            ])
    }
    
    private func windbarbChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                    .text("AAChartKit-Pro Wind Barbst"))
            .xAxis(AAXAxis()
                    .offset(40))
            .series([
                AASeriesElement()
                    .type(.windbarb)
                    .name("Wind")
                    .data(AAOptionsData.windbarbData),
                AASeriesElement()
                    .type(.area)
                    .name("Wind speed")
                    .data(AAOptionsData.windbarbData)
                    .keys(["y"])
                    .marker(AAMarker()
                                .fillColor(AAColor.white)//点的填充色(用来设置折线连接点的填充色)
                                .lineWidth(5)//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
                                .lineColor(""))//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色))
            ])
    }
    
    private func networkgraphChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.networkgraph))
            .title(AATitle()
                    .text("The Indo-European Laungauge Tree"))
            .subtitle(AASubtitle()
                        .text("A Force-Directed Network Graph in Highcharts"))
            .series([
                AASeriesElement()
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .data(AAOptionsData.networkgraphData),
            ])
    }
    
    private func wordcloudChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.wordcloud))
            .title(AATitle()
                    .text("词云图"))
            .series([
                AASeriesElement()
                    .data(AAOptionsData.wordcloudData),
            ])
    }
    
    private func eulerChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.venn))
            .title(AATitle()
                    .text("欧拉图和韦恩图的关系"))
            .tooltip(AATooltip()
                        .enabled(true)
                        .headerFormat((#"<span style="color:{point.color}">○</span>"#
                                        + #"<span style="font-size: 14px"> {point.point.name}</span><br/>"#).aa_toPureJSString())
                        .pointFormat(#"{point.description}<br><span style="font-size: 10px">Source: Wikipedia</span>"#.aa_toPureJSString())
            )
            
            .series([
                AASeriesElement()
                    .data(AAOptionsData.eulerData),
            ])
    }
    
    private func organizationChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
//                .height(600)
                .inverted(true))
            .title(AATitle()
                .text("Highsoft 公司组织结构"))
            .series([
                AASeriesElement()
                    .type(.organization)
                    .name("Highsoft")
                    .keys(["from", "to"])
                    .data(AAOptionsData.organizationData)
                    .levels([
                        AALevelsElement()
                            .level(0)
                            .color("silver")
                            .dataLabels(AADataLabels()
                                .color(AAColor.black))
                            .height(25)
                        ,
                        AALevelsElement()
                            .level(1)
                            .color("silver")
                            .dataLabels(AADataLabels()
                                .color(AAColor.black))
                            .height(25)
                        ,
                        AALevelsElement()
                            .level(2)
                            .color("#980104"),
                        AALevelsElement()
                            .level(4)
                            .color("#359154")
                        ])
                    .nodes(AAOptionsData.organizationNodesData)
                    .colorByPoint(false)
                    .color("#007ad0")
                    .dataLabels(AADataLabels()
                        .color(AAColor.white))
                    .borderColor(AAColor.white)
                    .nodeWidth(65)
                ])
            .tooltip(AATooltip()
                .outside(true)
            )
    }
    
    private func arcdiagramChart1() -> AAOptions {
        AAOptions()
            .colors(["#293462", "#a64942", "#fe5f55", "#fff1c1", "#5bd1d7", "#ff502f", "#004d61", "#ff8a5c", "#fff591", "#f5587b", "#fad3cf", "#a696c8", "#5BE7C4", "#266A2E", "#593E1A", ])
            .title(AATitle()
                .text("Main train connections in Europe"))
            .series([
                AASeriesElement()
                    .keys(["from", "to", "weight"])
                    .type(.arcdiagram)
                    .name("Train connections")
                    .linkWeight(1)
                    .centeredLinks(true)
                    .dataLabels(AADataLabels()
                        .rotation(90)
                        .y(30)
                        .align(.left)
                        .color(AAColor.black))
                    .offset("65%")
                    .data(AAOptionsData.arcdiagram1Data)
                ])
    }
    
    private func arcdiagramChart2() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("Highcharts Arc Diagram"))
            .subtitle(AASubtitle()
                .text("Arc Diagram with marker symbols"))
            .series([
                AASeriesElement()
                    .linkWeight(1)
                    .keys(["from", "to", "weight"])
                    .type(.arcdiagram)
                    .marker(AAMarker()
                        .symbol(AAChartSymbolType.triangle.rawValue)
                        .lineWidth(2)
                        .lineColor(AAColor.white))
                    .centeredLinks(true)
                    .dataLabels(AADataLabels()
                        .format("{point.fromNode.name} → {point.toNode.name}")
                        .nodeFormat("{point.name}")
                        .color(AAColor.black)
                        .linkTextPath(AATextPath()
                            .enabled(true))
                               )
                    .data(AAOptionsData.arcdiagram2Data)
                ])
    }
    
    private func arcdiagramChart3() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .inverted(true))
            .title(AATitle()
                .text("Highcharts Inverted Arc Diagram"))
            .series([
                AASeriesElement()
                    .keys(["from", "to", "weight"])
//                    .centerPos("50%")
                    .type(.arcdiagram)
                    .dataLabels(AADataLabels()
                        .align(.right)
                        .x(-20)
                        .y(-2)
                        .color("#333333")
                        .overflow("allow")
                        .padding(0)
                               )
                    .offset("60%")
                    .data(AAOptionsData.arcdiagram3Data)
                ])
    }
    
//    The Highcharts flame chart implementation is based on inverted chart with columnrange series (for the flame and icicle layouts)
//    and a sunburst series (for the sunburst layout).
    private func flameChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .inverted(true))
            .title(AATitle()
                .align(.left)
                .text("Flame chart (layout: flame)"))
            .subtitle(AASubtitle()
                .align(.left)
                .text("Highcharts chart rendering process"))
            .legend(AALegend()
                .enabled(false))
            .xAxisArray([
                AAXAxis()
                    .visible(false),
                AAXAxis()
                    .visible(false)
                    .startOnTick(false)
                    .endOnTick(false)
                    .minPadding(0)
                    .maxPadding(0)
                ])
            .yAxisArray([
                AAYAxis()
                    .visible(false),
                AAYAxis()
                    .visible(false)
                    .min(0)
                    .maxPadding(0)
                    .startOnTick(false)
                    .endOnTick(false)
                ])
            .series([
                AASeriesElement()
                    .type(.flame)
                    .data(AAOptionsData.flameData)
                    .yAxis(1)
                    .xAxis(1),
                AASeriesElement()
                    .visible(false)
                    .size("100%")
                    .type(.sunburst)
                    .data(AAOptionsData.sunburst2Data)
                    .allowDrillToNode(true)
                    .cursor("pointer")
                    .levels([
                        AALevelsElement()
                            .level(1)
//                            .levelIsConstant(false)
                            .dataLabels(AADataLabels()
                                .enabled(false))
                        ])
                    .dataLabels(AADataLabels()
                        .textPath(AATextPath()
                            .attributes(["dy": 5])
                            .enabled(true)))
                ])
            .tooltip(AATooltip()
                .headerFormat("")
                .pointFormat("selfSize of {point.name} is {point.value}"))
    }
    
    private func icicleChart() -> AAOptions {
        let aaOptions = flameChart()
        
        aaOptions.chart?.inverted(true)
        
        let aaXAxisElement = aaOptions.xAxisArray![1]
        aaXAxisElement.reversed(false)
        
        aaOptions.title?.text("Flame chart (layout: icicle)")
        
        let element1: AASeriesElement = aaOptions.series?[0] as! AASeriesElement
        let element2: AASeriesElement = aaOptions.series?[1] as! AASeriesElement
        element1.visible(true)
        element2.visible(false)
        
        return aaOptions
    }
    
    private func sunburstChart2() -> AAOptions {
        let aaOptions = flameChart()
        
        aaOptions.chart?.inverted(false)
        
        let aaXAxisElement = aaOptions.xAxisArray![1]
        aaXAxisElement.reversed(true)
        
        aaOptions.title?.text("Flame chart (layout: sunburst)")
        
        let element1: AASeriesElement = aaOptions.series?[0] as! AASeriesElement
        let element2: AASeriesElement = aaOptions.series?[1] as! AASeriesElement
        element1.visible(false)
        element2.visible(true)

        return aaOptions
    }
    
    private func packedbubbleSpiralChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.packedbubble)
//                .height("100%")
            )
            .title(AATitle()
                .text("Carbon emissions around the world (2014)"))
            .tooltip(AATooltip()
                .useHTML(true)
                .pointFormat("{point.name}: {point.y}m CO2"))
            .plotOptions(AAPlotOptions()
                .packedbubble(AAPackedbubble()
                    .useSimulation(false)
                    .minSize("20%")
                    .maxSize("80%")
                    .dataLabels(AADataLabels()
                        .enabled(true)
                        .format("{point.name}")
                        .filter(AAFilter()
                            .property("y")
                            .operator(">")
                            .value(250))
                        .style(AAStyle()
                            .color(AAColor.black)
                            .textOutline("none")
                            .fontWeight(.regular)))))
            .series(AAOptionsSeries.packedbubbleSeries)
    }
    
    private func generalDrawingChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .backgroundColor(AAColor.white)
                .events(AAChartEvents()
                    .load("""
            function () {
                var ren = this.renderer,
                    colors = Highcharts.getOptions().colors,
                    rightArrow = ['M', 0, 0, 'L', 100, 0, 'L', 95, 5, 'M', 100, 0, 'L', 95, -5],
                    leftArrow = ['M', 100, 0, 'L', 0, 0, 'L', 5, 5, 'M', 0, 0, 'L', 5, -5];


                ren.path(['M', 120, 40, 'L', 120, 330])
                    .attr({
                        'stroke-width': 2,
                        stroke: 'silver',
                        dashstyle: 'dash'
                    })
                    .add();

                ren.path(['M', 420, 40, 'L', 420, 330])
                    .attr({
                        'stroke-width': 2,
                        stroke: 'silver',
                        dashstyle: 'dash'
                    })
                    .add();

                ren.label('Web client', 20, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();
                ren.label('Web service / CLI', 220, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();
                ren.label('Command line client', 440, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();

                ren.label('SaaS client<br/>(browser or<br/>script)', 10, 82)
                    .attr({
                        fill: colors[0],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white'
                    })
                    .add()
                    .shadow(true);

                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .translate(95, 95)
                    .add();

                ren.label('POST options in JSON', 90, 75)
                    .css({
                        fontSize: '10px',
                        color: colors[3]
                    })
                    .add();

                ren.label('PhantomJS', 210, 82)
                    .attr({
                        r: 5,
                        width: 100,
                        fill: colors[1]
                    })
                    .css({
                        color: 'white',
                        fontWeight: 'bold'
                    })
                    .add();

                ren.path(['M', 250, 110, 'L', 250, 185, 'L', 245, 180, 'M', 250, 185, 'L', 255, 180])
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .add();

                ren.label('SVG', 255, 120)
                    .css({
                        color: colors[3],
                        fontSize: '10px'
                    })
                    .add();

                ren.label('Batik', 210, 200)
                    .attr({
                        r: 5,
                        width: 100,
                        fill: colors[1]
                    })
                    .css({
                        color: 'white',
                        fontWeight: 'bold'
                    })
                    .add();

                ren
                    .path([
                        'M', 235, 185,
                        'L', 235, 155,
                        'C', 235, 130, 235, 130, 215, 130,
                        'L', 95, 130,
                        'L', 100, 125,
                        'M', 95, 130,
                        'L', 100, 135
                    ])
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .add();

                ren.label('Rasterized image', 100, 110)
                    .css({
                        color: colors[3],
                        fontSize: '10px'
                    })
                    .add();

                ren.label('Browser<br/>running<br/>Highcharts', 10, 180)
                    .attr({
                        fill: colors[0],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white',
                        width: '100px'
                    })
                    .add()
                    .shadow(true);


                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[1]
                    })
                    .translate(95, 205)
                    .add();

                ren.label('POST SVG', 110, 185)
                    .css({
                        color: colors[1],
                        fontSize: '10px'
                    })
                    .add();

                ren.path(leftArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[1]
                    })
                    .translate(95, 215)
                    .add();

                ren.label('Rasterized image', 100, 215)
                    .css({
                        color: colors[1],
                        fontSize: '10px'
                    })
                    .add();

                ren.label('Script', 450, 82)
                    .attr({
                        fill: colors[2],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white',
                        width: '100px'
                    })
                    .add()
                    .shadow(true);

                ren.path(leftArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[2]
                    })
                    .translate(330, 90)
                    .add();

                ren.label('Command', 340, 70)
                    .css({
                        color: colors[2],
                        fontSize: '10px'
                    })
                    .add();

                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[2]
                    })
                    .translate(330, 100)
                    .add();

                ren.label('Rasterized image', 330, 100)
                    .css({
                        color: colors[2],
                        fontSize: '10px'
                    })
                    .add();
            }
""")))
            .title(AATitle()
                .text("Highcharts export server overview")
                .style(AAStyle.init(color: AAColor.black)))
    }
    
    private func solidgaugeChart() -> AAOptions {
        let seriesArr = [
            AASeriesElement()
                .name("Move")
                .data([
                    AASolidgaugeDataElement()
                        .color("#7cb5ec")
                        .radius("112%")
                        .innerRadius("88%")
                        .y(80)
                    ]),
            AASeriesElement()
                .name("Exercise")
                .data([
                    AASolidgaugeDataElement()
                        .color("#434348")
                        .radius("87%")
                        .innerRadius("63%")
                        .y(65)
                    ]),
            AASeriesElement()
                .name("Stand")
                .data([
                    AASolidgaugeDataElement()
                        .color("#90ed7d")
                        .radius("62%")
                        .innerRadius("39%")
                        .y(50)
                    ]),
            AASeriesElement()
                .name("Move")
                .data([
                    AASolidgaugeDataElement()
                        .color("#f7a35c")
                        .radius("38%")
                        .innerRadius("28%")
                        .y(80)
                    ]),
            AASeriesElement()
                .name("Exercise")
                .data([
                    AASolidgaugeDataElement()
                        .color("#8085e9")
                        .radius("27%")
                        .innerRadius("17%")
                        .y(65)
                    ]),
            AASeriesElement()
                .name("Stand")
                .data([
                    AASolidgaugeDataElement()
                        .color("#f15c80")
                        .radius("16%")
                        .innerRadius("6%")
                        .y(50)
                    ])
            ]
        
        return AAOptions()
            .chart(AAChart()
                .type(AAChartType.solidgauge)
//                .height("110%")
//                .events(AAChartEvents()
//                    .render(#"""
//                    function renderIcons() {
//
//                // Move icon
//                if (!this.series[0].icon) {
//                    this.series[0].icon = this.renderer.path(['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8])
//                        .attr({
//                            stroke: '#303030',
//                            'stroke-linecap': 'round',
//                            'stroke-linejoin': 'round',
//                            'stroke-width': 2,
//                            zIndex: 10
//                        })
//                        .add(this.series[2].group);
//                }
//                this.series[0].icon.translate(
//                    this.chartWidth / 2 - 10,
//                    this.plotHeight / 2 - this.series[0].points[0].shapeArgs.innerR -
//                    (this.series[0].points[0].shapeArgs.r - this.series[0].points[0].shapeArgs.innerR) / 2
//                );
//
//                // Exercise icon
//                if (!this.series[1].icon) {
//                    this.series[1].icon = this.renderer.path(
//                        ['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8,
//                            'M', 8, -8, 'L', 16, 0, 8, 8
//                        ]
//                    )
//                        .attr({
//                            stroke: '#ffffff',
//                            'stroke-linecap': 'round',
//                            'stroke-linejoin': 'round',
//                            'stroke-width': 2,
//                            zIndex: 10
//                        })
//                        .add(this.series[2].group);
//                }
//                this.series[1].icon.translate(
//                    this.chartWidth / 2 - 10,
//                    this.plotHeight / 2 - this.series[1].points[0].shapeArgs.innerR -
//                    (this.series[1].points[0].shapeArgs.r - this.series[1].points[0].shapeArgs.innerR) / 2
//                );
//
//                // Stand icon
//                if (!this.series[2].icon) {
//                    this.series[2].icon = this.renderer.path(['M', 0, 8, 'L', 0, -8, 'M', -8, 0, 'L', 0, -8, 8, 0])
//                        .attr({
//                            stroke: '#303030',
//                            'stroke-linecap': 'round',
//                            'stroke-linejoin': 'round',
//                            'stroke-width': 2,
//                            zIndex: 10
//                        })
//                        .add(this.series[2].group);
//                }
//
//                this.series[2].icon.translate(
//                    this.chartWidth / 2 - 10,
//                    this.plotHeight / 2 - this.series[2].points[0].shapeArgs.innerR -
//                    (this.series[2].points[0].shapeArgs.r - this.series[2].points[0].shapeArgs.innerR) / 2
//                );
//            }
//                    """#))
            )
            .title(AATitle()
                .text("Activity")
                .style(AAStyle()
                    .fontSize(24)))
            .tooltip(AATooltip()
                .borderWidth(0)
                .backgroundColor("none")
                .shadow(false)
                .style(AAStyle()
                    .fontSize(16)
                    .textOutline("3px"))
                .valueSuffix("%")
//                .pointFormat("{series.name}
//        {point.y}")
                .positioner(#"""
                function(labelWidth) {
                        return {
                            x: (this.chart.chartWidth - labelWidth) / 2 - 100,
                            y: (this.chart.plotHeight / 2) + 15
                        };
                    }
                """#))
            .pane(AAPane()
                .startAngle(0)
                .endAngle(360)
                .background([
                    AABackgroundElement()
                        .outerRadius("112%")
                        .innerRadius("88%")
                        .backgroundColor("rgba(124,181,236,0.3)")
                        .borderWidth(0),
                    AABackgroundElement()
                        .outerRadius("87%")
                        .innerRadius("63%")
                        .backgroundColor("rgba(67,67,72,0.3)")
                        .borderWidth(0),
                    AABackgroundElement()
                        .outerRadius("62%")
                        .innerRadius("38%")
                        .backgroundColor("rgba(144,237,125,0.3)")
                        .borderWidth(0)
                    ]))
            .yAxis(AAYAxis()
                .min(0)
                .max(100)
                .lineWidth(0)
                .tickPositions([]))
//            .plotOptions(AAPlotOptions()
//                .solidgauge(AASolidgauge()
//                    .dataLabels(AADataLabels()
//                        .enabled(false))
//                    .linecap("round")
//                    .stickyTracking(false)
//                    .rounded(true)))
            .series(seriesArr)
    }

}
