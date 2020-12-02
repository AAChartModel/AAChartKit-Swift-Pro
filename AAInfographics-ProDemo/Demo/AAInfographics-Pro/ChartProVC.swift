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
        case 0: return sankeyChart()
        case 1: return variablepieChart()
        case 2: return treemapWithLevelsData()
        case 3: return variwideChart()
        case 4: return sunburstChart()
        case 5: return dependencywheelChart()
        case 6: return heatmapChart()
        case 7: return packedbubbleChart()
        case 8: return packedbubbleSplitChart()
        case 9: return vennChart()
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

        default:
            return sankeyChart()
        }
    }
    
    
    
    private func sankeyChart() -> AAOptions {
        return AAOptions()
            .title(AATitle()
                    .text("AAChartKit-Pro 桑基图"))
            .colors([
                "rgb(137,78,36)",
                "rgb(220,36,30)",
                "rgb(255,206,0)",
                "rgb(1,114,41)",
                "rgb(0,175,173)",
                "rgb(215,153,175)",
                "rgb(106,114,120)",
                "rgb(114,17,84)",
                "rgb(0,0,0)",
                "rgb(0,24,168)",
                "rgb(0,160,226)",
                "rgb(106,187,170)"
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
        let aaOptionsQ = AAOptions()
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
        return aaOptionsQ
    }
    
    private func treemapWithLevelsData() -> AAOptions {
        let aaOptions = AAOptions()
            .title(AATitle()
                    .text("Fruit Consumption Situation"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AASeriesElement()
                    .type(.treemap)
                    .levels([
                        AALevels()
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
        return aaOptions
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
            .type("category")
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
        let aaOptionsQ = AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
        return aaOptionsQ
    }
    
    private func sunburstChart() -> AAOptions {
        let aaChart = AAChart()
            .type(.variwide)
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
                .type(.sunburst)
                .allowDrillToNode(true)
                .levels([
                    AALevels()
                        .level(2)
                        .colorByPoint(true)
                        .layoutAlgorithm("sliceAndDice")
                    //                              .dataLabels({
                    //                                      "rotationMode": "parallel"
                    //                              })
                    ,
                    AALevels()
                        .level(3)
                        .colorVariation(AAColorVariation()
                                            .key("brightness")
                                            .to(-0.5)),
                    AALevels()
                        .level(4)
                        .colorVariation(AAColorVariation()
                                            .key("brightness")
                                            .to(0.5))
                    
                ])
                .data(AAOptionsData.sunburstData)
        ]
        let aaOptions = AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
        return aaOptions
    }
    
    private func dependencywheelChart() -> AAOptions  {
        return AAOptions()
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
                                    //                         .textPath({
                                    //                             "enabled": true,
                                    //                             "attributes": {
                                    //                                     "dy": 5
                                    //                             }
                                    //                                      })
                                    .distance(10))
            ])
    }
    
    
    // https://jshare.com.cn/demos/hhhhiz
    private func heatmapChart() -> AAOptions {
        return AAOptions()
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
                            .text(""))
            )
            .colorAxis(AAColorAxis()
                        .min(0)
                        .minColor("#FFFFFF")
                        .maxColor("#7cb5ec"))
            .legend(AALegend()
                        .enabled(true)
                        .align(.right)
                        .layout(.vertical)
                        .verticalAlign(.top)
                        .y(25)
            )
            .tooltip(AATooltip()
                        .enabled(true)
                        .formatter("""
                    function () {
                    return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> sold <br><b>' +
                        this.point.value + '</b> items on <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>'            }
                    """
                        )
            )
            .series([
                AASeriesElement()
                    .name("Sales")
                    .borderWidth(1)
                    .data(AAOptionsData.heatmapData)
                    .dataLabels(AADataLabels()
                                    .enabled(true)
                                    .color("red")
                    )
            ])
    }
    
    
    // https://www.highcharts.com.cn/demo/highcharts/packed-bubble
    private func packedbubbleChart() -> AAOptions {
        return AAOptions()
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
                                            .layoutAlgorithm(AALayoutAlgorithm() //只有layoutAlgorithm这一段不一样
                                                                .gravitationalConstant(0.02)
                                                                .splitSeries(false)
                                            )
                                            .dataLabels(AADataLabels()
                                                            .enabled(true)
                                                            .format("{point.name}")
                                                            .filter([
                                                                "property": "y",
                                                                "operator": ">",
                                                                "value": 250
                                                            ])
                                            )))
            .series(AAOptionsSeries.packedbubbleSeries)
        
        
    }
    
    // https://www.highcharts.com.cn/demo/highcharts/packed-bubble-split
    private func packedbubbleSplitChart() -> AAOptions {
        return AAOptions()
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
                                            .layoutAlgorithm(AALayoutAlgorithm() //只有layoutAlgorithm这一段不一样
                                                                .gravitationalConstant(0.05)
                                                                .splitSeries(true)
                                                                .seriesInteraction(false)
                                                                .dragBetweenSeries(true)
                                                                .parentNodeLimit(true))
                                            .dataLabels(AADataLabels()
                                                            .enabled(true)
                                                            .format("{point.name}")
                                                            .filter([
                                                                "property": "y",
                                                                "operator": ">",
                                                                "value": 250
                                                            ])
                                            )))
            .series(AAOptionsSeries.packedbubbleSeries)
    }
    
    
    private func vennChart() -> AAOptions {
        return AAOptions()
            .title(AATitle()
                    .text("The Unattainable Triangle"))
            .series([
                        AASeriesElement()
                            .type(.venn)
                            .data(AAOptionsData.vennData)])
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
            .type("category")
        
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
        
        let aaOptionsQ = AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .yAxis(aaYAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
        return aaOptionsQ
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
            .type("category")
        
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
        
        let aaOptionsQ = AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .xAxis(aaXAxis)
            .yAxis(aaYAxis)
            .tooltip(aaTooltip)
            .legend(aaLegend)
            .series(seriesElementArr)
        return aaOptionsQ
    }
    
    private func streamgraphChart() -> AAOptions {
        return AAOptions()
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
                    .type("category")
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
        return AAOptions()
            .chart(AAChart()
                    .type(.columnpyramid))
            .title(AATitle()
                    .text("世界 5 大金字塔"))
            .xAxis(AAXAxis()
                    .visible(true)
                    .type("category")
            )
            .yAxis(AAYAxis()
                    .visible(true)
                    .title(AATitle()
                            .text("高度 (m)"))
            )
            .tooltip(AATooltip()
                        .enabled(true)
                        .valueSuffix(" m")
            )
            .series([
                AASeriesElement()
                    .name("Height")
                    .colorByPoint(true)
                    .data(AAOptionsData.columnpyramidData)
            ])
    }
    
    private func tilemapChart() -> AAOptions {
        return AAOptions()
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
                            AADataClasses()
                                .from(0)
                                .to(1000000)
                                .color("#F9EDB3")
                                .name("< 1M"),
                            AADataClasses()
                                .from(1000000)
                                .to(5000000)
                                .color("#FFC428")
                                .name("1M - 5M"),
                            AADataClasses()
                                .from(5000000)
                                .to(20000000)
                                .color("#F9EDB3")
                                .name("5M - 20M"),
                            AADataClasses()
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
                                                        .color("#ffffff")
                                                        .style(AAStyle()
                                                                .textOutline("none"))
                                        )))
            .series([
                AASeriesElement()
                    .name("Height")
                    .colorByPoint(true)
                    .data(AAOptionsData.tilemapData)
            ])
    }
    
    private func treemapWithColorAxisData() -> AAOptions {
        return AAOptions()
            .chart(AAChart()
                    .type(.treemap))
            .title(AATitle()
                    .text("矩形树图"))
            .colorAxis(AAColorAxis()
                        .minColor("#FFFFFF")
                        .maxColor("#FF0000")
            )
            .series([
                AASeriesElement()
                    .data(AAOptionsData.treemapWithColorAxisData)
            ])
    }
    
    private func drilldownTreemapChart() -> AAOptions {
        return AAOptions()
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
                                AALevels()
                                    .level(1)
                                    .dataLabels(AADataLabels()
                                                    .enabled(true))
                                    .borderWidth(3)])
                    .data(AAOptionsData.drilldownTreemapData)
            ])
    }
    
    private func xrangeChart() -> AAOptions {
        return AAOptions()
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
            .series([[
                "borderRadius":2,
                "pointPadding": 0,
                "groupPadding": 0,
                "data": AAOptionsData.xrangeData
            ]])
    }
    
    private func vectorChart() -> AAOptions {
        return AAOptions()
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
        let aaOptions = AAOptions()
            .title(AATitle()
                    .text("Bell curve"))
            //    .xAxisArray([
            //        AATitle()
            //        .text("Data"),
            //        AATitle()
            //        .text("Bell curve")
            //                  ])
            //    .yAxisArray([
            //        AATitle()
            //        .text("Data"),
            //        AATitle()
            //        .text("Bell curve")
            //                  ])
            .series([
//                        [
//                            "name": "Bell curve",
//                            "type": "bellcurve",
//                            "xAxis": 1,
//                            "yAxis": 1,
//                            "baseSeries": 1,
//                            "zIndex": -1
//                        ],
                        AASeriesElement()
                            .name("Bell curve")
                            .type(.bellcurve)
                            
                        
                        ,
                        
                        AASeriesElement()
                            .name("Data")
                            .type(.scatter)
                            .marker(AAMarker()
                                        .fillColor("#ffffff")//点的填充色(用来设置折线连接点的填充色)
                                        .lineWidth(2)//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
                                        .lineColor(""))//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色))
                            .data(AAOptionsData.bellcurveData)])
        return aaOptions
    }
    
    private func timelineChart() -> AAOptions {
        let aaOptions = AAOptions()
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
        return aaOptions
    }
    
    private func itemChart() -> AAOptions {
        let aaOptions = AAOptions()
            .chart(AAChart()
                    .type(.item))
            .title(AATitle()
                    .text("AAChartKit-Pro item chart"))
            .subtitle(AASubtitle()
                        .text("Parliament visualization"))
            .legend(AALegend()
                        .enabled(false))
            .series([
                AASeriesElement()
                    .name("Representatives")
                    .keys(["name","y","color","label"])
                    .data(AAOptionsData.itemData)
                    .dataLabels(AADataLabels()
                                    .enabled(false))
                    .size("170%")
            ])
        return aaOptions
    }
    
    private func windbarbChart() -> AAOptions {
        let aaOptions = AAOptions()
            .title(AATitle()
                    .text("AAChartKit-Pro Wind Barbst"))
            //    .xAxis((id){
            //        "offset": 40
            //                  })
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
                                .fillColor("#ffffff")//点的填充色(用来设置折线连接点的填充色)
                                .lineWidth(5)//外沿线的宽度(用来设置折线连接点的轮廓描边的宽度)
                                .lineColor(""))//外沿线的颜色(用来设置折线连接点的轮廓描边颜色，当值为空字符串时，默认取数据点或数据列的颜色))
            ])
        return aaOptions
    }
    
    private func networkgraphChart() -> AAOptions {
        let aaOptions = AAOptions()
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
        return aaOptions
    }
    
    private func wordcloudChart() -> AAOptions {
        let aaOptions = AAOptions()
            .chart(AAChart()
                    .type(.wordcloud))
            .title(AATitle()
                    .text("词云图"))
            .series([
                AASeriesElement()
                    .data(AAOptionsData.wordcloudData),
            ])
        return aaOptions
    }
    
    private func eulerChart() -> AAOptions {
        let aaOptions = AAOptions()
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
        return aaOptions
    }
}
