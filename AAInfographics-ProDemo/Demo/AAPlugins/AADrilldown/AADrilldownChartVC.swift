//
//  AABubbleChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AADrilldownChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"AADrilldown" ofType:@"js"];
         self.aaChartView.pluginsArray = @[jsPath];
         */
//        let jsPath: String = Bundle.main.path(forResource: "AADrilldown", ofType: "js") ?? ""
//        self.aaChartView?.pluginsArray = [jsPath]

    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AADrilldownChartComposer.columnChart().pluginsArray([Bundle.main.path(forResource: "AADrilldown", ofType: "js") ?? ""])
//        case 1: return AABubbleChartComposer.packedbubbleSplitChart()
//        case 2: return AABubbleChartComposer.packedbubbleSpiralChart()
//        case 3: return AABubbleChartComposer.eulerChart()
//        case 4: return AABubbleChartComposer.vennChart()
        default: return nil
        }
    }

}

