//
//  AABubbleChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import UIKit

class AABubbleChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AABubbleChartComposer.packedbubbleChart()
        case 1: return AABubbleChartComposer.packedbubbleSplitChart()
        case 2: return AABubbleChartComposer.packedbubbleSpiralChart()
        case 3: return AABubbleChartComposer.eulerChart()
        case 4: return AABubbleChartComposer.vennChart()
        case 5: return AABubbleChartComposer.vennChart2()
        case 6: return AABubbleChartComposer.eulerChart2()
        case 7: return AABubbleStellarChartComposer.bubbleStellarChart()
        default: return nil
        }
    }

}
