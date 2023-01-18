//
//  AAHeatOrTreeMapChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import UIKit

class AAHeatOrTreeMapChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

//    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
//        switch (selectedIndex) {
//        case 0: return AAHeatOrTreeMapChartComposer.heatmapChart()
////        case 1: return AAHeatOrTreeMapChartComposer.tilemapChart()
//        case 2: return AAHeatOrTreeMapChartComposer.treemapWithColorAxisData()
//        case 3: return AAHeatOrTreeMapChartComposer.treemapWithLevelsData()
//        case 4: return AAHeatOrTreeMapChartComposer.drilldownLargeDataTreemapChart()
//        case 5: return AAHeatOrTreeMapChartComposer.largeDataHeatmapChart()
//        case 6: return AAHeatOrTreeMapChartComposer.simpleTilemapWithHexagonTileShape()
//        case 7: return AAHeatOrTreeMapChartComposer.simpleTilemapWithCircleTileShape()
//        case 8: return AAHeatOrTreeMapChartComposer.simpleTilemapWithDiamondTileShape()
//        case 9: return AAHeatOrTreeMapChartComposer.simpleTilemapWithSquareTileShape()
//        case 10: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithHexagonTileShape()
//        case 11: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithCircleTileShape()
//        case 12: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithDiamondTileShape()
//        case 13: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithSquareTileShape()
//        case 14: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithHexagonTileShape()
//        case 15: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithCircleTileShape()
//        case 16: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithDiamondTileShape()
//        case 17: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithSquareTileShape()
//
//        default: return nil
//        }
//    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AAHeatOrTreeMapChartComposer.heatmapChart()
        case 1: return AAHeatOrTreeMapChartComposer.treemapWithColorAxisData()
        case 2: return AAHeatOrTreeMapChartComposer.treemapWithLevelsData()
        case 3: return AAHeatOrTreeMapChartComposer.drilldownLargeDataTreemapChart()
        case 4: return AAHeatOrTreeMapChartComposer.largeDataHeatmapChart()
        case 5: return AAHeatOrTreeMapChartComposer.simpleTilemapWithHexagonTileShape()
        case 6: return AAHeatOrTreeMapChartComposer.simpleTilemapWithCircleTileShape()
        case 7: return AAHeatOrTreeMapChartComposer.simpleTilemapWithDiamondTileShape()
        case 8: return AAHeatOrTreeMapChartComposer.simpleTilemapWithSquareTileShape()
        case 9: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithHexagonTileShape()
        case 10: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithCircleTileShape()
        case 11: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithDiamondTileShape()
        case 12: return AAHeatOrTreeMapChartComposer.tilemapForAfricaWithSquareTileShape()
        case 13: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithHexagonTileShape()
        case 14: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithCircleTileShape()
        case 15: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithDiamondTileShape()
        case 16: return AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithSquareTileShape()

        default: return nil
        }
    }



}
