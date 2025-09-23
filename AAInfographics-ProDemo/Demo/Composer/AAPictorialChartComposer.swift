//
//  AAPictorialChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/23.
//

import UIKit

class AAPictorialChartComposer: NSObject {
    
    // Kelvin color temperature scale chart
    static func pictorial1Chart() -> AAOptions {
        return AAOptions()
            .chart(AAChart()
                .type(AAChartType.pictorial))
            .colors(["#B0FDFE", "#E3FED4", "#F9F492", "#FAF269", "#FAE146", "#FDA003"])
            .title(AATitle()
                .text("Kelvin color temperature scale chart"))
            .subtitle(AASubtitle())
            .xAxis(AAXAxis()
                .visible(true)
                .min(0.2))
            .yAxis(AAYAxis()
                .visible(true))
            .legend(AALegend()
                .align(AAChartAlignType.right)
                .floating(true)
                .itemMarginTop(5)
                .itemMarginBottom(5)
                .layout(AAChartLayoutType.vertical)
                // .margin(0)
                // .padding(0)
                .verticalAlign(AAChartVerticalAlignType.middle))
            .tooltip(AATooltip()
                .headerFormat("")
                .valueSuffix(" K"))
            .plotOptions(AAPlotOptions()
                .pictorial(AAPictorial()
                    .pointPadding(0)
                    .groupPadding(0)
                    // .borderWidth(0)
                    .dataLabels(AADataLabels()
                        .enabled(true)
                        .align(AAChartAlignType.center)
                        .format("{y} K"))
                    .stacking("percent")
                    .paths([
                        AAPathsElement()
                            .definition(kWomanPath),
                        AAPathsElement()
                            .definition(kManPath)
                    ])))
            .series(AAOptionsSeries.pictorial2Series)
    }

    static func pictorial2Chart() -> AAOptions {
        return AAOptions()
            .chart(AAChart()
                .type(AAChartType.pictorial))
            .title(AATitle()
                .text("Composition of the human body"))
            .xAxis(AAXAxis()
                .categories(["Woman", "Man"])
                .lineWidth(0)
                .opposite(true))
            .yAxis(AAYAxis()
                .visible(false)
                // .stackShadow(AAStackingShadow()
                //     .enabled(true))
                .max(100))
            .legend(AALegend()
                .itemMarginTop(15)
                .itemMarginBottom(15)
                .layout(AAChartLayoutType.vertical)
    // .padding(0)
                .verticalAlign(AAChartVerticalAlignType.middle)
                .align(AAChartAlignType.center)
                // .margin(0)
            )
            .tooltip(AATooltip()
                .headerFormat(""))
            .plotOptions(AAPlotOptions()
                .pictorial(AAPictorial()
                    .pointPadding(0)
                    .groupPadding(0)
                    .dataLabels(AADataLabels()
                        .enabled(true)
                        .align(AAChartAlignType.center)
                        .format("{y} %"))
                    .stacking("normal")
                    .paths([
                        AAPathsElement()
                            .definition(kBulbPath)
                    ])))
            .series(AAOptionsSeries.pictorial2Series)
    }

}
