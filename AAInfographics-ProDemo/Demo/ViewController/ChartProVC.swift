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

    // https://www.highcharts.com/demo
    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case  0: return sunburstChart()
        case  1: return streamgraphChart()
        case  2: return vectorChart()
        case  3: return bellcurveChart()
        case  4: return timelineChart()
        case  5: return itemChart()
        case  6: return windbarbChart()
        case  7: return wordcloudChart()
        case  8: return flameChart()
        case  9: return itemChart2()
        case 10: return itemChart3()
        case 11: return icicleChart()
        case 12: return sunburstChart2()
        case 13: return solidgaugeChart()
        case 14: return parallelCoordinatesSplineChart()
        case 15: return parallelCoordinatesLineChart()
        case 16: return volinPlotChart()
        case 17: return variablepieChart()
        case 18: return semicircleSolidGaugeChart()

        default: return nil
        }
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

    func dicStringToPrettyString(dic: Any) -> String {
        return String(data: try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted), encoding: .utf8)!
    }
    
    private func configureVirturalTemperatureDataArr() -> [Any] {
        var dataArr = [Any]()
        for month in 1...12 {
            var daysNum = 30
            if month == 1 || month == 3 || month == 5 || month == 7 || month == 10 || month == 12 {
                daysNum = 31
            } else if month == 2 {
                daysNum = 28
            }
            for day in 1...daysNum {
                for hour in 1...24 {
                    let dayStr = "2013-\(month)-\(day)"
                    let hourNum = hour - 1
                    let temperature = (arc4random() % 10)
//                    "Date,Time,Temperature
                    let dataElement = ["Date":dayStr, "Time": hourNum, "Temperature": temperature] as [String: Any]
                    dataArr.append(dataElement)
                }
            }
        }
//        print("\(dicStringToPrettyString(dic: dataArr))")
        return dataArr
    }
    
    private func solidgaugeChart() -> AAOptions {
         AAOptions()
            .chart(AAChart()
                .type(AAChartType.solidgauge)
//                .height("110%")
                .events(AAChartEvents()
                    .load("""
                    function () {
                    
                    if (!this.series[0].icon) {
                        this.series[0].icon = this.renderer.path(['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8])
                            .attr({
                                stroke: '#303030',
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': 2,
                                zIndex: 10
                            })
                            .add(this.series[2].group);
                    }
                    this.series[0].icon.translate(
                        this.chartWidth / 2 - 10,
                        this.plotHeight / 2 - this.series[0].points[0].shapeArgs.innerR -
                            (this.series[0].points[0].shapeArgs.r - this.series[0].points[0].shapeArgs.innerR) / 2
                    );

                    if (!this.series[1].icon) {
                        this.series[1].icon = this.renderer.path(
                            ['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8,
                                'M', 8, -8, 'L', 16, 0, 8, 8]
                        )
                            .attr({
                                stroke: '#ffffff',
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': 2,
                                zIndex: 10
                            })
                            .add(this.series[2].group);
                    }
                    this.series[1].icon.translate(
                        this.chartWidth / 2 - 10,
                        this.plotHeight / 2 - this.series[1].points[0].shapeArgs.innerR -
                            (this.series[1].points[0].shapeArgs.r - this.series[1].points[0].shapeArgs.innerR) / 2
                    );

                    if (!this.series[2].icon) {
                        this.series[2].icon = this.renderer.path(['M', 0, 8, 'L', 0, -8, 'M', -8, 0, 'L', 0, -8, 8, 0])
                            .attr({
                                stroke: '#303030',
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': 2,
                                zIndex: 10
                            })
                            .add(this.series[2].group);
                    }

                    this.series[2].icon.translate(
                        this.chartWidth / 2 - 10,
                        this.plotHeight / 2 - this.series[2].points[0].shapeArgs.innerR -
                            (this.series[2].points[0].shapeArgs.r - this.series[2].points[0].shapeArgs.innerR) / 2
                    );
                    }
                    """))
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
                .pointFormat(#"{series.name}<br><span style="font-size:2em; color: {point.color}; font-weight: bold">{point.y}</span>"#.aa_toPureJSString())
                .positioner("""
                function(labelWidth) {
                    return {
                        x: (this.chart.chartWidth - labelWidth) / 2 - 100,
                        y: (this.chart.plotHeight / 2) - 100
                    };
                }
                """))
            .pane(AAPane()
                .startAngle(0)
                .endAngle(360)
                .background([
                    AABackgroundElement()
                        .outerRadius("112%")
                        .innerRadius("88%")
                        .backgroundColor(AARgba(124,181,236,0.3))
                        .borderWidth(0),
                    AABackgroundElement()
                        .outerRadius("87%")
                        .innerRadius("63%")
                        .backgroundColor(AARgba(67,67,72,0.3))
                        .borderWidth(0),
                    AABackgroundElement()
                        .outerRadius("62%")
                        .innerRadius("38%")
                        .backgroundColor(AARgba(144,237,125,0.3))
                        .borderWidth(0)
                    ]))
            .yAxis(AAYAxis()
                .min(0)
                .max(100)
                .lineWidth(0)
                .tickPositions([]))
            .plotOptions(AAPlotOptions()
                .solidgauge(AASolidgauge()
                    .dataLabels(AADataLabels()
                        .enabled(false))
                    .linecap("round")
                    .stickyTracking(false)
                    .rounded(true)))
            .series([
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
                ])
    }

    private func parallelCoordinatesSplineChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.spline)
                .parallelCoordinates(true)
                .parallelAxes(AAParallelAxes()
                    .lineWidth(2)))
            .title(AATitle()
                .text("Marathon set"))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
//                    .animation(false)
                    .marker(AAMarker()
                        .enabled(false)
                        .states(AAMarkerStates()
                            .hover(AAMarkerHover()
                                .enabled(false))))
                    .states(AAStates()
                        .hover(AAHover()
                            .halo(AAHalo()
                                .size(0))))
                    .events(AAEvents()
                        .mouseOver(#"""
                        function () {
                                this.group.toFront();
                            }
                        """#))))
            .tooltip(AATooltip()
                .pointFormat((#"<span style="color:{point.color}">\u25CF</span>"# +
                              "{series.name}: <b>{point.formattedValue}</b><br/>").aa_toPureJSString()))
            .xAxis(AAXAxis()
                .categories([
                    "Training date",
                    "Miles for training run",
                    "Training time",
                    "Shoe brand",
                    "Running pace per mile",
                    "Short or long",
                    "After 2004",
                ])
                .offset(10))
            .yAxisArray([
                AAYAxis()
                    .type(.datetime)
                    .tooltipValueFormat("{value:%Y-%m-%d}")
                ,
                AAYAxis()
                    .min(0)
                    .tooltipValueFormat("{value} mile(s)")
                ,
                AAYAxis()
                    .type(.datetime)
                    .min(0)
                    .labels(AALabels()
                        .format("{value:%H:%M}")),
                AAYAxis()
                    .categories([
                        "Other",
                        "Adidas",
                        "Mizuno",
                        "Asics",
                        "Brooks",
                        "New Balance",
                        "Izumi",
                    ]),
                AAYAxis()
                    .type(.datetime),
                AAYAxis()
                    .categories([
                        "> 5miles",
                        "< 5miles",
                    ]),
                AAYAxis()
                    .categories([
                        "Before",
                        "After",
                    ])
                ])
//            .colors(["rgba(11, 200, 200, 0.1)", ])
            .colors([AARgba(255, 0, 0, 0.1),])
            .series(AAOptionsData.marathonData.map({ dataSet in
                return AASeriesElement()
                    .name("Runner")
                    .data(dataSet as! [Any])
                    .shadow(AAShadow()
                        .width(0))
            }))
    }
    
    private func parallelCoordinatesLineChart() -> AAOptions {
        let aaOptions = parallelCoordinatesSplineChart()
        aaOptions.chart?.type(.line)
        aaOptions.colors([AAGradientColor.linearGradient(
            direction: .toRight,
            stops: [
                [0.00, "#febc0f0F"],//颜色字符串设置支持十六进制类型和 rgba 类型
                [0.25, "#FF14d4E6"],
                [0.50, "#0bf8f5E6"],
                [0.75, "#F33c52E6"],
                [1.00, "#1904ddE6"],
            ]
        )])
        return aaOptions
    }

    private func volinPlotChart() -> AAOptions {
         AAOptions()
                .chart(AAChart()
                        .type(.streamgraph)
                        .inverted(true))
                .title(AATitle()
                        .text("The 2012 Olympic rowing athletes weight"))
                .xAxis(AAXAxis()
                        .reversed(false)
                        .labels(AALabels()
                                .format("{value} kg"))
                        .gridLineWidth(1)
                        .crosshair(AACrosshair()
                                .color(AAColor.lightGray)
                                .dashStyle(.longDashDotDot)))
                .yAxisArray([
                    AAYAxis()
                            //                    .width("45%")
                            .offset(0)
                            .visible(false),
                    AAYAxis()
                            //                    .width("45%")
                            //                    .left("55%")
                            .offset(0)
                            .visible(false)
                ])
                .tooltip(AATooltip()
                        //                .split(true)
                        .headerFormat("")
                        .pointFormat("{series.name}: {point.x} kg"))
                .series([
                    AASeriesElement()
                            .name("Male")
                            .data(AAOptionsData.volinPlotElement1Data)
                            .color("#a8d4ff")
                            .yAxis(0),
                    AASeriesElement()
                            .name("Female")
                            .color("#ffa8d4")
                            .data(AAOptionsData.volinPlotElement2Data)
                            .yAxis(1)
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

    //https://www.highcharts.com/forum/viewtopic.php?f=9&t=49662&p=181012#p181048
    private func semicircleSolidGaugeChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                    .type(.solidgauge))
            .title(AATitle()
                    .text("Big Fella")
                    .style(AAStyle()
                            .fontSize(36)))
            .tooltip(AATooltip()
                    .enabled(false))
            .pane(AAPane()
                    .center(["50%", "70%"])
                    .size("100%")
                    .startAngle(-90)
                    .endAngle(90)
                    .background([
                        AABackgroundElement()
                            .backgroundColor("#EEE")
                            .innerRadius("60%")
                            .outerRadius("100%")
                            .shape("arc")
                    ]))
            .plotOptions(AAPlotOptions()
                            .solidgauge(AASolidgauge()
                                            .dataLabels(AADataLabels()
                                                            .y(-64)
                                                            .borderWidth(0)
                                                            .useHTML(true)
                                                            .format(#"""
                                                                    <div style="text-align:center">
                                                                        <span style="font-size:48px">{y}</span><br/>
                                                                        <span style="font-size:20px;opacity:0.4">pounds</span>
                                                                    </div>
                                                                    """#.aa_toPureJSString2()))))
            .yAxis(AAYAxis()
                    .min(0)
                    .max(100)
                    .tickWidth(0)
                    .minorTickInterval(0)
                    .tickAmount(2)
                    .labels(AALabels()
                                .distance(-45)
                                .y(32)
                                .style(AAStyle()
                                        .fontSize(20))))
            .series([
                AASeriesElement()
                    .type(.solidgauge)
                    .data([72])
            ])
    }


}


public extension String {
    func aa_toPureJSString2() -> String {
        //https://stackoverflow.com/questions/34334232/why-does-function-not-work-but-function-does-chrome-devtools-node
        var pureJSStr = "\(self)"
        pureJSStr = pureJSStr.replacingOccurrences(of: "'", with: "\"")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\0", with: "")
//        pureJSStr = pureJSStr.replacingOccurrences(of: "\n", with: "")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\\", with: "\\\\")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\"", with: "\\\"")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\n", with: "\\n")
        pureJSStr = pureJSStr.replacingOccurrences(of: "\r", with: "\\r")
//        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{000C}", with: "\\f")
//        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
//        pureJSStr = pureJSStr.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        return pureJSStr
    }

}
