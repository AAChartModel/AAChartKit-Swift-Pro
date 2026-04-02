//
//  AASankeyChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

class AASankeyChartComposer {

    static func sankeyDiagramChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("Estimated US Energy Consumption in 2022"))
            .subtitle(AASubtitle()
                .text("Source: <a href='https://www.llnl.gov/'> Lawrence Livermore National Laboratory</a>".aa_toPureHTMLString()))
            .tooltip(AATooltip()
                .headerFormat("")
                .formatter(#"""
                function () {
                    if (this.point && this.point.isNode) {
                        return this.point.name + ': ' + Highcharts.numberFormat(this.point.sum || 0, 2) + ' quads';
                    }
                    return this.point.fromNode.name + ' → ' + this.point.toNode.name + ': '
                        + Highcharts.numberFormat(this.point.weight || 0, 2) + ' quads';
                }
                """#))
            .series(AAOptionsSeries.sankeyDiagramSeries)
    }

    static func verticalSankeyChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .type(.sankey)
                .inverted(true))
            .title(AATitle()
                .text("Evaluating the energy consumed for water use in the United States")
                .align(.left))
            .subtitle(AASubtitle()
                .text("Data source: <a href='https://iopscience.iop.org/article/10.1088/1748-9326/7/3/034034/pdf'>The University of Texas at Austin</a>".aa_toPureHTMLString())
                .align(.left))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .states(AAStates()
                        .inactive(AAInactive()
                            .enabled(false)))
                    .dataLabels(AADataLabels()
                        .formatter(#"""
                        function () {
                            const point = this.point;
                            if (!point || !point.isNode) {
                                return this.point.name || '';
                            }
                            const maxLetters = point.shapeArgs ? point.shapeArgs.height / 8 : point.name.length;
                            const firstWord = point.name.slice(0, maxLetters);
                            return (firstWord.length >= point.name.length ? firstWord : point.name).toUpperCase();
                        }
                        """#)
                        .style(AAStyle()
                            .textOutline("none")
                            .color("#4a4a4a")))))
            .tooltip(AATooltip()
                .formatter(#"""
                function () {
                    if (this.point && this.point.isNode) {
                        return this.point.name + ': <b>' + Highcharts.numberFormat(this.point.sum || 0, 2) + ' quads</b>';
                    }
                    return this.point.fromNode.name + ' → ' + this.point.toNode.name + ': '
                        + Highcharts.numberFormat(this.point.weight || 0, 2) + ' quads';
                }
                """#))
            .series(AAOptionsSeries.verticalSankeySeries)
    }
}
