//
//  ChartSampleProvider.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/18.
//

import UIKit

class ChartSampleProvider: NSObject {
    
    // MARK: - 关系图表
    class func relationshipChartSamples() -> [AAOptions] {
        return [
            AARelationshipChartComposer.sankeyChart(),
            AARelationshipChartComposer.dependencywheelChart(),
            AARelationshipChartComposer.arcdiagramChart1(),
            AARelationshipChartComposer.arcdiagramChart2(),
            AARelationshipChartComposer.arcdiagramChart3(),
            AARelationshipChartComposer.organizationChart(),
            AARelationshipChartComposer.networkgraphChart(),
            AARelationshipChartComposer.simpleDependencyWheelChart(),
        ]
    }
    
    // MARK: - 气泡图表
    class func bubbleChartSamples() -> [AAOptions] {
        return [
            AABubbleChartComposer.packedbubbleChart(),
            AABubbleChartComposer.packedbubbleSplitChart(),
            AABubbleChartComposer.packedbubbleSpiralChart(),
            AABubbleChartComposer.eulerChart(),
            AABubbleChartComposer.vennChart(),
        ]
    }
    
    // MARK: - 柱状图变体
    class func columnVariantChartSamples() -> [AAOptions] {
        return [
            AAColumnVariantChartComposer.variwideChart(),
            AAColumnVariantChartComposer.columnpyramidChart(),
            AAColumnVariantChartComposer.dumbbellChart(),
            AAColumnVariantChartComposer.lollipopChart(),
            AAColumnVariantChartComposer.xrangeChart(),
            AAColumnVariantChartComposer.invertedXrangeChart(),
            AAColumnVariantChartComposer.histogramChart(),
            AAColumnVariantChartComposer.bellcurveChart(),
            AAColumnVariantChartComposer.bulletChart(),
        ]
    }
    
    // MARK: - 热力图和树状图
    class func heatAndTreeMapChartSamples() -> [AAOptions] {
        return [
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
        ]
    }
    
    // MARK: - 树形图
    class func treegraphChartSamples() -> [AAOptions] {
        return [
            AATreegraphChartComposer.treegraph(),
            AATreegraphChartComposer.invertedTreegraph(),
            AATreegraphChartComposer.treegraphWithBoxLayout(),
        ]
    }
    
    // MARK: - 其他专业图表
    class func otherProChartSamples() -> [AAOptions] {
        return [
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
    
    // MARK: - 所有专业图表样本（原始方法）
    class func allProTypeSamples() -> [AAOptions] {
        return (
            relationshipChartSamples() +
            bubbleChartSamples() +
            columnVariantChartSamples() +
            heatAndTreeMapChartSamples() +
            treegraphChartSamples() +
            otherProChartSamples()
        )
    }

}
