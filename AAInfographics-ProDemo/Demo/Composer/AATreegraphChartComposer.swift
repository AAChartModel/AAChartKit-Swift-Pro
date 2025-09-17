//
//  AATreegraphChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/17.
//

import Foundation

class AATreegraphChartComposer {
    
    static func treegraph() -> AAOptions {
        var aaOptions = invertedTreegraph()
        aaOptions.chart?.inverted = false
        return aaOptions
    }
    
    static func invertedTreegraph() -> AAOptions {
        return AAOptions()
            .chart(AAChart()
                .inverted(true)
                .marginBottom(170)
            )
            .title(AATitle()
                .text("Inverted treegraph")
                .align(.left)
            )
            .series([
                AASeriesElement()
                    .type(.treegraph)
                    .data(AAOptionsData.treegraphData)
                    .tooltip(AATooltip()
                        .pointFormat("{point.name}")
                    )
                    .dataLabels(AADataLabels()
                        .format("{point.name}")
                        .style(AAStyle()
                            .whiteSpace("nowrap")
                            .color("#000000")
                            .textOutline("3px contrast")
                        )
                            .crop(false)
                    )
                    .marker(AAMarker()
                        .radius(6)
                    )
                    .levels([
                        AALevelsElement()
                            .level(1)
                            .dataLabels(AADataLabels()
                                .align(.left)
                                .x(20)
                            ),
                        AALevelsElement()
                            .level(2)
                            .colorByPoint(true)
                            .dataLabels(AADataLabels()
                                .verticalAlign(.bottom)
                                .y(-20)
                            ),
                        AALevelsElement()
                            .level(3)
                            .colorVariation(AAColorVariation()
                                .key("brightness")
                                .to(-0.5)
                            )
                            .dataLabels(AADataLabels()
                                .align(.left)
                                .rotation(90)
                                .y(20)
                            )
                    ])
            ])
    }
    
    static func treegraphWithBoxLayout() -> AAOptions {
        return AAOptions()
            .title(AATitle()
                .text("Treegraph with box layout")
            )
            .series([
                AASeriesElement()
                    .type(.treegraph)
                    .data(AAOptionsData.treegraphData)
                    .tooltip(AATooltip()
                        .pointFormat("{point.name}")
                    )
                    .marker(AAMarker()
                        .symbol("rect")
//                        .width("25%")
                    )
                    .borderRadius(10)
                    .dataLabels(AADataLabels()
                        .format("{point.name}")
                        .style(AAStyle()
                            .whiteSpace("nowrap")
                        )
                    )
                    .levels([
                        AALevelsElement()
                            .level(1)
                        // .levelIsConstant(false)
                        ,
                        AALevelsElement()
                            .level(2)
                            .colorByPoint(true),
                        AALevelsElement()
                            .level(3)
                            .colorVariation(AAColorVariation()
                                .key("brightness")
                                .to(-0.5)
                            ),
                        AALevelsElement()
                            .level(4)
                            .colorVariation(AAColorVariation()
                                .key("brightness")
                                .to(0.5)
                            )
                    ])
            ])
    }

    
}
