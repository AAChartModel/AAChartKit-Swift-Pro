//
//  AABubbleChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AABubbleChartComposer {
    
    // https://www.highcharts.com.cn/demo/highcharts/packed-bubble
    static func packedbubbleChart() -> AAOptions {
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
                        .splitSeries(false))
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
    static func packedbubbleSplitChart() -> AAOptions {
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
    
    static func packedbubbleSpiralChart() -> AAOptions {
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
    
    static func vennChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("The Unattainable Triangle"))
            .series([
                AASeriesElement()
                    .type(.venn)
                    .data(AAOptionsData.vennData)
            ])
    }
    
    static func eulerChart() -> AAOptions {
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
    
}


