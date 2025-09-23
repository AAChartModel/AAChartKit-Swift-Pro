//
//  AAOrganizationChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/23.
//

import UIKit

class AAOrganizationChartComposer: NSObject {
    
    static func germanicLanguageTreeChart() -> AAOptions {
        let colors: [String] = ["#1e90ff", "#ef476f", "#ffd066", "#04d69f", "#25547c"]
        
        return AAOptions()
            .chart(AAChart()
                // .height(1200)
                .inverted(true))
            .title(AATitle()
                .text("The Germanic Language Tree"))
//            .accessibility(Accessibility()
//                .point(AccessibilityPoint()
//                    .descriptionFormat("{add index 1}. {toNode.id} comes from {fromNode.id}")))
            .tooltip(AATooltip()
                .outside(true))
        
            .plotOptions(AAPlotOptions()
                .organization(AAOrganization()
                    .hangingIndentTranslation("cumulative")
                    // Crimp a bit to avoid nodes overlapping lines
                    .hangingIndent(10)))
        
            .series([
                AASeriesElement()
                    .name("Germanic language tree")
                    .type(.organization)
                    .keys(["from", "to"])
                    .nodeWidth(40)
                    .nodePadding(20)
                    .colorByPoint(false)
//                  .hangingIndentTranslation("cumulative")
//                  // Crimp a bit to avoid nodes overlapping lines
//                  .hangingIndent(10)
                    .levels([
                        AALevelsElement()
                            .level(0)
                            .color("#dedede"),
                        AALevelsElement()
                            .level(1)
                            .color("#dedede"),
                        AALevelsElement()
                            .level(2)
                            .color(colors[3]),
                        AALevelsElement()
                            .level(3)
                            .color(colors[2]),
                        AALevelsElement()
                            .level(4)
                            .color(colors[4])
                    ])
                    .nodes({
                        let originalLeafsArr: [String] = [
                            "Bastarnisch", "Brabantian", "Burgundian", "Crimean Gothic", "Danish",
                            "Dutch", "English", "Faroese", "Flemish", "Frisian", "Gepidisch", "Gothic",
                            "Herulisch", "(High) German", "Hollandic", "Icelandic", "Limburgish",
                            "Low German", "Norwegian", "Rhinelandic", "Rugisch", "Skirisch", "Swedish",
                            "Vandalic", "Yiddish"
                        ]
                        
                        var leafs: [[String: Any]] = []
                        for leaf in originalLeafsArr {
                            let leafDict: [String: Any] = ["id": leaf, "color": colors[0]]
                            leafs.append(leafDict)
                        }
                        
                        let hangingNodes: [[String: Any]] = [
                            [
                                "id": "North Germanic",
                                "layout": "hanging",
                                "offsetHorizontal": -15
                            ],
                            [
                                "id": "West Germanic",
                                "layout": "hanging"
                            ],
                            [
                                "id": "East Germanic",
                                "layout": "hanging"
                            ]
                        ]
                        
                        let nodes = hangingNodes + leafs
                        return nodes
                    }())
                    .data(AAOptionsData.germanicLanguageTreeData)
            ])
    }
}
