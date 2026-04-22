//
//  AABubbleStellarChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import Foundation

class AABubbleStellarChartComposer {

    static func bubbleStellarChart() -> AAOptions {
        let colors = ["#6CDDCA", "#C771F3", "#4D90DB", "#FAB776"]
        let planetData = parsePlanetData()

        return AAOptions()
            .chart(AAChart()
                .type(.bubble)
                .polar(true))
            .title(AATitle()
                .text("The 240 Closest Planets to the Earth other than our solar system"))
            .subtitle(AASubtitle()
                .text("Using bubble series in polar coordinate system along with pie series"))
            .legend(AALegend()
                .enabled(false))
            .pane(AAPane()
                .size("95%")
                .background([
                    AABackgroundElement()
                        .backgroundColor("#f7f7f7")
                        .borderWidth(0),
                    AABackgroundElement()
                        .backgroundColor("#fff")
                        .borderWidth(0)
                        .innerRadius("42%")
                        .outerRadius("42%")
                ]))
            .xAxis(AAXAxis()
                .tickInterval(1)
                .min(0)
                .max(30)
                .gridLineWidth(0)
                .labels(AALabels()
                    .enabled(false))
                .lineWidth(0))
            .yAxis(AAYAxis()
                .tickInterval(1)
                .labels(AALabels()
                    .enabled(false))
                .gridLineWidth(0.5)
                .gridLineColor("#BBBAC5")
                .gridLineDashStyle(.longDash)
                .endOnTick(false))
            .tooltip(AATooltip()
                .useHTML(true)
                .shadow(false)
                .formatter(#"""
                function () {
                    if (this.series.options.type === 'pie') {
                        return false;
                    }

                    return '<table>'
                        + '<tr><td style="padding:0"><span class="smallerLabel">Name:</span> ' + this.point.name + '</td></tr>'
                        + '<tr><td style="padding:0"><span class="smallerLabel">Mass:</span> ' + this.point.custom.planetMass + '</td></tr>'
                        + '<tr><td style="padding:0"><span class="smallerLabel">Distance:</span> ' + this.point.custom.lightYears + ' Light Years</td></tr>'
                        + '<tr><td style="padding:0"><span class="smallerLabel">Stellar Magnitude:</span> ' + this.point.custom.stellarMagnitude + '</td></tr>'
                        + '</table>';
                }
                """#))
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .states(AAStates()
                        .inactive(AAInactive()
                            .enabled(false)))))
            .series([
                AASeriesElement()
                    .name("Closest planets")
                    .data(planetData),
                AASeriesElement()
                    .type(.pie)
                    .size("40%")
                    .innerSize("85%")
                    .zIndex(-1)
                    .dataLabels(AADataLabels()
                        .enabled(false))
                    .data([
                        ["y": 12, "color": colors[0]],
                        ["y": 47, "color": colors[1]],
                        ["y": 117, "color": colors[2]],
                        ["y": 64, "color": colors[3]],
                    ])
            ])
    }

    private static func parsePlanetData() -> [Any] {
        guard let csvString = AAOptionsCSV.stellarChartData["csv"] as? String else {
            return []
        }

        let rows = csvString.split(separator: "\n", omittingEmptySubsequences: true)
        guard rows.count > 1 else {
            return []
        }

        return rows.dropFirst().compactMap { row in
            let columns = row.split(separator: ";", omittingEmptySubsequences: false).map(String.init)
            guard columns.count >= 8 else {
                return nil
            }

            let name = columns[0]
            let x = Int(columns[1]) ?? 0
            let y = Int(columns[2]) ?? 0
            let z = Double(columns[3].replacingOccurrences(of: ",", with: ".")) ?? 0
            let lightYears = columns[4]
            let planetMass = columns[5]
            let stellarMagnitude = columns[6]
            let discoveryDate = Int(columns[7]) ?? 0

            return [
                "name": name,
                "x": x,
                "y": y,
                "z": z,
                "custom": [
                    "lightYears": lightYears,
                    "planetMass": planetMass,
                    "stellarMagnitude": stellarMagnitude,
                    "discoveryDate": discoveryDate,
                ]
            ]
        }
    }
}
