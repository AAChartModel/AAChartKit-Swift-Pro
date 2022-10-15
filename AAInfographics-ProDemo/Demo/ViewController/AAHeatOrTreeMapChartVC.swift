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

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AAHeatOrTreeMapChartComposer.heatmapChart()
        case 1: return AAHeatOrTreeMapChartComposer.tilemapChart()
        case 2: return AAHeatOrTreeMapChartComposer.treemapWithColorAxisData()
        case 3: return AAHeatOrTreeMapChartComposer.treemapWithLevelsData()
        case 4: return AAHeatOrTreeMapChartComposer.drilldownLargeDataTreemapChart()
        case 5: return AAHeatOrTreeMapChartComposer.largeDataHeatmapChart()
        default: return nil
        }
    }


}
