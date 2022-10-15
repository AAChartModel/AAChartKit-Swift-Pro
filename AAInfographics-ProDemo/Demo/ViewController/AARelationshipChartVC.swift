//
//  AARelationshipChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import UIKit

class AARelationshipChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AARelationshipChartComposer.sankeyChart()
        case 1: return AARelationshipChartComposer.dependencywheelChart()
        case 2: return AARelationshipChartComposer.arcdiagramChart1()
        case 3: return AARelationshipChartComposer.arcdiagramChart2()
        case 4: return AARelationshipChartComposer.arcdiagramChart3()
        case 5: return AARelationshipChartComposer.organizationChart()
        case 6: return AARelationshipChartComposer.networkgraphChart()
        default: return nil
        }
    }

}
