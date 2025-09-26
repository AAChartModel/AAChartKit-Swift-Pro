//
//  AARelationshipChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AARelationshipChartComposer {
    
    static func sankeyChart() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("AAChartKit-Pro 桑基图"))
            .colors([
                AARgba(137, 78, 36),
                AARgba(220, 36, 30),
                AARgba(255, 206, 0),
                AARgba(1, 114, 41),
                AARgba(0, 175, 173),
                AARgba(215, 153, 175),
                AARgba(106, 114, 120),
                AARgba(114, 17, 84),
                AARgba(0, 0, 0),
                AARgba(0, 24, 168),
                AARgba(0, 160, 226),
                AARgba(106, 187, 170)
            ])
            .series([
                AASeriesElement()
                    .type(.sankey)
                    .keys(["from", "to", "weight"])
                    .data(AAOptionsData.sankeyData),
            ])
    }
    
    static func dependencywheelChart() -> AAOptions {
        AAOptions()
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
                        .textPath(AATextPath()
                            .enabled(true)
                            .attributes([
                                "dy": 5
                            ]))
                            .distance(10))
            ])
    }
    
    static func arcdiagramChart1() -> AAOptions {
        AAOptions()
            .colors(["#293462", "#a64942", "#fe5f55", "#fff1c1", "#5bd1d7", "#ff502f", "#004d61", "#ff8a5c", "#fff591", "#f5587b", "#fad3cf", "#a696c8", "#5BE7C4", "#266A2E", "#593E1A", ])
            .title(AATitle()
                .text("Main train connections in Europe"))
            .series([
                AASeriesElement()
                    .keys(["from", "to", "weight"])
                    .type(.arcdiagram)
                    .name("Train connections")
                    .linkWeight(1)
                    .centeredLinks(true)
                    .dataLabels(AADataLabels()
                        .rotation(90)
                        .y(30)
                        .align(.left)
                        .color(AAColor.black))
                    .offset("65%")
                    .data(AAOptionsData.arcdiagram1Data)
            ])
    }
    
    static func arcdiagramChart2() -> AAOptions {
        AAOptions()
            .title(AATitle()
                .text("Highcharts Arc Diagram"))
            .subtitle(AASubtitle()
                .text("Arc Diagram with marker symbols"))
            .series([
                AASeriesElement()
                    .linkWeight(1)
                    .keys(["from", "to", "weight"])
                    .type(.arcdiagram)
                    .marker(AAMarker()
                        .symbol(AAChartSymbolType.triangle.rawValue)
                        .lineWidth(2)
                        .lineColor(AAColor.white))
                    .centeredLinks(true)
                    .dataLabels(AADataLabels()
                        .format("{point.fromNode.name} → {point.toNode.name}")
                        .nodeFormat("{point.name}")
                        .color(AAColor.black)
                        .linkTextPath(AATextPath()
                            .enabled(true))
                    )
                    .data(AAOptionsData.arcdiagram2Data)
            ])
    }
    
    static func arcdiagramChart3() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                .inverted(true))
            .title(AATitle()
                .text("Highcharts Inverted Arc Diagram"))
            .series([
                AASeriesElement()
                    .keys(["from", "to", "weight"])
                //                    .centerPos("50%")
                    .type(.arcdiagram)
                    .dataLabels(AADataLabels()
                        .align(.right)
                        .x(-20)
                        .y(-2)
                        .color("#333333")
                        .overflow("allow")
                        .padding(0)
                    )
                    .offset("60%")
                    .data(AAOptionsData.arcdiagram3Data)
            ])
    }
    
    static func organizationChart() -> AAOptions {
        AAOptions()
            .chart(AAChart()
                   //                .height(600)
                .inverted(true))
            .title(AATitle()
                .text("Highsoft 公司组织结构"))
            .series([
                AASeriesElement()
                    .type(.organization)
                    .name("Highsoft")
                    .keys(["from", "to"])
                    .data(AAOptionsData.organizationData)
                    .levels([
                        AALevelsElement()
                            .level(0)
                            .color("silver")
                            .dataLabels(AADataLabels()
                                .color(AAColor.black))
                            .height(25)
                        ,
                        AALevelsElement()
                            .level(1)
                            .color("silver")
                            .dataLabels(AADataLabels()
                                .color(AAColor.black))
                            .height(25)
                        ,
                        AALevelsElement()
                            .level(2)
                            .color("#980104"),
                        AALevelsElement()
                            .level(4)
                            .color("#359154")
                    ])
                    .nodes(AAOptionsData.organizationNodesData)
                    .colorByPoint(false)
                    .color("#007ad0")
                    .dataLabels(AADataLabels()
                        .color(AAColor.white))
                    .borderColor(AAColor.white)
                    .nodeWidth(65)
            ])
            .tooltip(AATooltip()
                .outside(true)
            )
    }
    
    static func networkgraphChart() -> AAOptions {
        AAOptions()
            .beforeDrawChartJavaScript(
                """
                // Add the nodes option through an event call. We want to start with the parent
                // item and apply separate colors to each child element, then the same color to
                // grandchildren.
                Highcharts.addEvent(
                    Highcharts.Series,
                    'afterSetOptions',
                    function (e) {

                        const colors = Highcharts.getOptions().colors,
                            nodes = {};

                        let i = 0;

                        if (
                            this instanceof Highcharts.Series.types.networkgraph &&
                            e.options.id === 'lang-tree'
                        ) {
                            e.options.data.forEach(function (link) {

                                if (link[0] === 'Proto Indo-European') {
                                    nodes['Proto Indo-European'] = {
                                        id: 'Proto Indo-European',
                                        marker: {
                                            radius: 20
                                        }
                                    };
                                    nodes[link[1]] = {
                                        id: link[1],
                                        marker: {
                                            radius: 10
                                        },
                                        color: colors[i++]
                                    };
                                } else if (nodes[link[0]] && nodes[link[0]].color) {
                                    nodes[link[1]] = {
                                        id: link[1],
                                        color: nodes[link[0]].color
                                    };
                                }
                            });

                            e.options.nodes = Object.keys(nodes).map(function (id) {
                                return nodes[id];
                            });
                        }
                    }
                );
                """
            )
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
    }
    
    //- (AAOptions *)simpleDependencyWheelChart {
    //    return AAOptions.new
    //        .titleSet(AATitle.new
    //            .textSet(@"2016 BRICS export in million USD"))
    //        .colorsSet(@[@"#058DC7", @"#8dc705", @"#c73f05", @"#ffc080", @"#dd69ba", ])
    //        .seriesSet(@[
    //            AASeriesElement.new
    //                .keysSet(@[@"from", @"to", @"weight", ])
    //                .dataSet(AAOptionsData.simpleDependencyWheelData)
    //                .typeSet(AAChartTypeDependencywheel)
    //                .nameSet(@"Dependency wheel series")
    //                .dataLabelsSet(AADataLabels.new
    //                    .colorSet(@"#333")
    //                    .textPathSet(AATextPath.new
    //                        .enabledSet(true)
    ////                        .attributesSet(AAAttributes.new
    ////                            .dySet(@5))
    //            )
    ////                    .distanceSet(@10)
    //            )
    ////                .sizeSet(@"95%")
    //            ]);
    //}

    static func simpleDependencyWheelChart() -> AAOptions {
        AAOptions()
                .title(AATitle()
                        .text("2016 BRICS export in million USD"))
                .colors(["#058DC7", "#8dc705", "#c73f05", "#ffc080", "#dd69ba", ])
                .series([
                    AASeriesElement()
                            .keys(["from", "to", "weight", ])
                            .data(AAOptionsData.simpleDependencyWheelData)
                            .type(.dependencywheel)
                            .name("Dependency wheel series")
                            .dataLabels(AADataLabels()
                                    .color("#333")
                                    .textPath(AATextPath()
                                            .enabled(true)
                                    )
                            )
                ])
    }
    
    
}
