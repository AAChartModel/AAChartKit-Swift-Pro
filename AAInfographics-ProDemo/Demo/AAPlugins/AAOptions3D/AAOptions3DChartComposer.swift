//
//  AAOptions3DChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

class AAOptions3DChartComposer {
    private static func randomStackSeries(stack: String) -> AASeriesElement {
        AASeriesElement()
            .stack(stack)
            .data((0...3).map { index in
                [
                    "x": index,
                    "y": Int.random(in: 0...10)
                ]
            })
    }

    static func _3DColumnWithStackingRandomData() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.column)
                .options3d(AAOptions3D()
                    .enabled(true)
                    .alpha(20)
                    .beta(30)
                    .depth(400)
                    .viewDistance(5)
                    .frame(AAFrame()
                        .bottom(["size": 1, "color": "rgba(0,0,0,0.05)"]))))
            .title(AATitle()
                .text(""))
            .subtitle(AASubtitle()
                .text(""))
            .yAxis(AAYAxis()
                .min(0)
                .max(10))
            .xAxis(AAXAxis()
                .min(0)
                .max(3)
                .gridLineWidth(1))
            .zAxis(AAZAxis()
                .min(0)
                .max(3)
                .categories(["A01", "A02", "A03", "A04", "A05", "A06", "A07", "A08", "A09", "A10", "A11", "A12"])
                .labels(AALabels()
                    .y(5)
                    .rotation(18)))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .groupZPadding(10)
                    .depth(100)
                    .groupPadding(0)
                    .grouping(false)))
            .series([
                randomStackSeries(stack: "0"),
                randomStackSeries(stack: "1"),
                randomStackSeries(stack: "2"),
                randomStackSeries(stack: "3"),
            ])
    }

    static func _3DBarWithStackingRandomData() -> AAOptions {
        let aaOptions = _3DColumnWithStackingRandomData()
        aaOptions.chart?.type(.bar)
        return aaOptions
    }

    static func _3DColumnWithStackingAndGrouping() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.column)
                .options3d(AAOptions3D()
                    .enabled(true)
                    .alpha(15)
                    .beta(15)
                    .viewDistance(25)
                    .depth(40)))
            .title(AATitle()
                .text("Electricity production in countries, grouped by continent")
                .align(.left))
            .xAxis(AAXAxis()
                .categories(["2018", "2019", "2020", "2021", "2022"]))
            .yAxis(AAYAxis()
                .allowDecimals(false)
                .min(0)
                .title(AATitle()
                    .text("TWh")))
            .tooltip(AATooltip()
                .headerFormat("<b>{point.key}</b><br>"))
            .plotOptions(AAPlotOptions()
                .column(AAColumn()
                    .stacking(AAChartStackingType.normal.rawValue))
                .series(AASeries()
                    .depth(40)))
            .series([
                AASeriesElement()
                    .name("South Korea")
                    .data([590, 582, 571, 606, 625])
                    .stack("Asia"),
                AASeriesElement()
                    .name("Germany")
                    .data([643, 612, 572, 588, 578])
                    .stack("Europe"),
                AASeriesElement()
                    .name("Saudi Arabia")
                    .data([378, 367, 363, 408, 433])
                    .stack("Asia"),
                AASeriesElement()
                    .name("France")
                    .data([582, 571, 533, 555, 473])
                    .stack("Europe"),
            ])
    }

    static func _3DBarWithStackingAndGrouping() -> AAOptions {
        let aaOptions = _3DColumnWithStackingAndGrouping()
        aaOptions.chart?.type(.bar)
        return aaOptions
    }

    static func _3DAreaChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.area)
                .options3d(AAOptions3D()
                    .enabled(true)
                    .alpha(15)
                    .beta(30)
                    .depth(200)))
            .title(AATitle()
                .text("Visual comparison of Mountains Panorama")
                .align(.left))
            .yAxis(AAYAxis()
                .title(AATitle()
                    .text("Height Above Sea Level")
                    .x(-40))
                .labels(AALabels()
                    .format("{value:,.0f} MAMSL"))
                .gridLineDashStyle(.dash))
            .xAxis(AAXAxis()
                .categories([
                    "Peak 1", "Peak 2", "Peak 3", "Peak 4", "Peak 5", "Peak 6"
                ]))
            .tooltip(AATooltip()
                .valueSuffix(" MAMSL"))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .depth(100)
                    .marker(AAMarker()
                        .enabled(false))
                    .states(AAStates()
                        .inactive(AAInactive()
                            .enabled(false)))))
            .series([
                AASeriesElement()
                    .name("Tatra Mountains visible from Rusinowa polana")
                    .color("rgb(200,110,50)")
                    .fillColor("rgb(200,110,50)")
                    .data([1890, 2009, 2152, 2142, 2061, 2230]),
                AASeriesElement()
                    .name("Dachstein panorama seen from Krippenstein")
                    .color("rgb(140,180,200)")
                    .fillColor("rgb(140,180,200)")
                    .data([2049, 2746, 2173, 2202, 2543, 2232]),
                AASeriesElement()
                    .name("Panorama from Col Des Mines")
                    .color("rgb(200,190,140)")
                    .fillColor("rgb(230,220,180)")
                    .data([4141, 4314, 3716, 3672, 3212, 3133]),
            ])
    }

    static func _3DScatterChart() -> AAOptions {
        var chart = AAChart()
            .type("scatter3d")
            .margin(top: 100, right: 100, bottom: 100, left: 100)
            .options3d(AAOptions3D()
                .enabled(true)
                .alpha(10)
                .beta(30)
                .depth(250)
                .viewDistance(5)
                .fitToPlot(false)
                .frame(AAFrame()
                    .bottom(["size": 1, "color": "rgba(0,0,0,0.02)"])
                    .back(["size": 1, "color": "rgba(0,0,0,0.04)"])
                    .side(["size": 1, "color": "rgba(0,0,0,0.06)"])))
        chart.animation = false

        let data: [Any] = (0..<100).map { _ in
            [
                Int.random(in: 0...9),
                Int.random(in: 0...9),
                Int.random(in: 0...9)
            ]
        }

        return AAOptions()
            .chart(chart)
            .title(AATitle()
                .text("Draggable box"))
            .subtitle(AASubtitle()
                .text("Click and drag the plot area to rotate in space"))
            .yAxis(AAYAxis()
                .min(0)
                .max(10)
                .title(AATitle()
                    .text(nil)))
            .xAxis(AAXAxis()
                .min(0)
                .max(10)
                .gridLineWidth(1))
            .zAxis(AAZAxis()
                .min(0)
                .max(10)
                .showFirstLabel(false))
            .legend(AALegend()
                .enabled(false))
            .series([
                AASeriesElement()
                    .name("Data")
                    .colorByPoint(true)
                    .data(data)
            ])
    }

    static func _3DPieChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.pie)
                .options3d(AAOptions3D()
                    .enabled(true)
                    .alpha(45)))
            .title(AATitle()
                .text("Beijing 2022 gold medals by country"))
            .subtitle(AASubtitle()
                .text("3D donut in Highcharts"))
            .plotOptions(AAPlotOptions()
                .pie(AAPie()
                    .depth(45)))
            .series([
                AASeriesElement()
                    .name("Medals")
                    .innerSize(100)
                    .data([
                        ["Norway", 16],
                        ["Germany", 12],
                        ["USA", 8],
                        ["Sweden", 8],
                        ["Netherlands", 8],
                        ["ROC", 6],
                        ["Austria", 7],
                        ["Canada", 4],
                        ["Japan", 3]
                    ])
            ])
    }
}
