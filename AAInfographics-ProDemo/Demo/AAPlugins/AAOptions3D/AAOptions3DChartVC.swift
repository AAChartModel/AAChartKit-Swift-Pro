//
//  AAOptions3DChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import UIKit

class AAOptions3DChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        let jsPath = Bundle.main.path(forResource: "AAHighcharts-3D", ofType: "js") ?? ""
        aaChartView?.userPluginPaths = [jsPath]
    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch selectedIndex {
        case 0: return AAOptions3DChartComposer._3DColumnWithStackingRandomData()
        case 1: return AAOptions3DChartComposer._3DColumnWithStackingAndGrouping()
        case 2: return AAOptions3DChartComposer._3DBarWithStackingRandomData()
        case 3: return AAOptions3DChartComposer._3DBarWithStackingAndGrouping()
        case 4: return AAOptions3DChartComposer._3DAreaChart()
        case 5: return AAOptions3DChartComposer._3DScatterChart()
        case 6: return AAOptions3DChartComposer._3DPieChart()
        default: return nil
        }
    }
}
