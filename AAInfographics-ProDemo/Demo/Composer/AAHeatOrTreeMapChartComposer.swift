//
//  AAHeatOrTreeMapChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AAHeatOrTreeMapChartComposer {
    
    // https://jshare.com.cn/demos/hhhhiz
    static func heatmapChart() -> AAOptions {
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

    static func tilemapChart() -> AAOptions {
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

    static func treemapWithColorAxisData() -> AAOptions {
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

    static func treemapWithLevelsData() -> AAOptions {
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
    
    static func drilldownLargeDataTreemapChart() -> AAOptions {
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

    static func largeDataHeatmapChart() -> AAOptions {
        let csvStr: String = AAOptionsCSV.csvData["csv"] as! String
        return AAOptions()
            .data(AAData()
                .csv(csvStr.aa_toPureJSString2())
                .parsed("""
                                function () {
                                            start = +new Date();
                                        }
                                """))
            .chart(AAChart()
                .type(.heatmap)
                .margin([60, 10, 80, 50]))
            .title(AATitle()
                .text("大型热力图")
                .align(.left)
                .x(40))
            .subtitle(AASubtitle()
                .text("2013每天每小时的热力变化")
                .align(.left)
                .x(40))
            .xAxis(AAXAxis()
                .type(AAChartAxisType.datetime)
                .min(1356998400000)
                .max(1388534400000)
                .labels(AALabels()
                    .align(.left)
                    .x(5)
                    .y(14)
                    .format("{value:%B}"))
                   //                .showLastLabel(false)
                .tickLength(16))
            .yAxis(AAYAxis()
                .title(AATitle()
                    .text(""))
                    .labels(AALabels()
                        .format("{value}:00"))
                        .minPadding(0)
                        .maxPadding(0)
                        .startOnTick(false)
                        .endOnTick(false)
                        .tickPositions([0, 6, 12, 18, 24])
                        .tickWidth(1)
                        .min(0)
                        .max(23)
                        .reversed(true))
            .colorAxis(AAColorAxis()
                .stops([
                    [0, "#3060cf", ],
                    [0.5, "#fffbbc", ],
                    [0.9, "#c4463a", ],
                    [1, "#c4463a", ]
                ])
                    .min(-15)
                    .max(25)
                    .startOnTick(false)
                    .endOnTick(false)
                    .labels(AALabels()
                        .format("{value}℃")))
            .series([
                AAHeatmap()
                    .borderWidth(0)
                    .colsize(86400000)
                //                    .data(configureVirturalTemperatureDataArr())
                    .tooltip(AATooltip()
                        .headerFormat("Temperature")
                        .pointFormat("{point.x:%e %b, %Y} {point.y}:00: {point.value} ℃"))
                    .turboThreshold(10000)
            ])
    }
    
}

