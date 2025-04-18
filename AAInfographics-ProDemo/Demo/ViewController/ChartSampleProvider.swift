//
//  ChartSampleProvider.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/18.
//

import UIKit

class ChartSampleProvider: NSObject {
    
    class func allProTypeSamples() -> [AAOptions] {
        return [
            AARelationshipChartComposer.sankeyChart(),
            AARelationshipChartComposer.dependencywheelChart(),
            AARelationshipChartComposer.arcdiagramChart1(),
            AARelationshipChartComposer.arcdiagramChart2(),
            AARelationshipChartComposer.arcdiagramChart3(),
            AARelationshipChartComposer.organizationChart(),
            AARelationshipChartComposer.networkgraphChart(),
            AARelationshipChartComposer.simpleDependencyWheelChart(),
            
            AABubbleChartComposer.packedbubbleChart(),
            AABubbleChartComposer.packedbubbleSplitChart(),
            AABubbleChartComposer.packedbubbleSpiralChart(),
            AABubbleChartComposer.eulerChart(),
            AABubbleChartComposer.vennChart(),
            
            AAColumnVariantChartComposer.variwideChart(),
            AAColumnVariantChartComposer.columnpyramidChart(),
            AAColumnVariantChartComposer.dumbbellChart(),
            AAColumnVariantChartComposer.lollipopChart(),
            AAColumnVariantChartComposer.xrangeChart(),
            AAColumnVariantChartComposer.histogramChart(),
            AAColumnVariantChartComposer.bellcurveChart(),
            AAColumnVariantChartComposer.bulletChart(),
            
            AAHeatOrTreeMapChartComposer.heatmapChart(),
            AAHeatOrTreeMapChartComposer.treemapWithColorAxisData(),
            AAHeatOrTreeMapChartComposer.treemapWithLevelsData(),
            AAHeatOrTreeMapChartComposer.drilldownLargeDataTreemapChart(),
            AAHeatOrTreeMapChartComposer.largeDataHeatmapChart(),
            AAHeatOrTreeMapChartComposer.simpleTilemapWithHexagonTileShape(),
            AAHeatOrTreeMapChartComposer.simpleTilemapWithCircleTileShape(),
            AAHeatOrTreeMapChartComposer.simpleTilemapWithDiamondTileShape(),
            AAHeatOrTreeMapChartComposer.simpleTilemapWithSquareTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapForAfricaWithHexagonTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapForAfricaWithCircleTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapForAfricaWithDiamondTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapForAfricaWithSquareTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithHexagonTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithCircleTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithDiamondTileShape(),
            AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithSquareTileShape(),
            
            ChartProVC.sunburstChart(),
            ChartProVC.streamgraphChart(),
            ChartProVC.vectorChart(),
            ChartProVC.bellcurveChart(),
            ChartProVC.timelineChart(),
            ChartProVC.itemChart(),
            ChartProVC.windbarbChart(),
            ChartProVC.wordcloudChart(),
            ChartProVC.flameChart(),
            ChartProVC.itemChart2(),
            ChartProVC.itemChart3(),
            ChartProVC.icicleChart(),
            ChartProVC.sunburstChart2(),
            ChartProVC.solidgaugeChart(),
//            ChartProVC.parallelCoordinatesSplineChart(),
//            ChartProVC.parallelCoordinatesLineChart(),
            ChartProVC.volinPlotChart(),
            ChartProVC.variablepieChart(),
            ChartProVC.semicircleSolidGaugeChart(),
        ]
    }

}
