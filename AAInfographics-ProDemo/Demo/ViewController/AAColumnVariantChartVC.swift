//
//  AAColumnVariantChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import UIKit

class AAColumnVariantChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        case 0: return AAColumnVariantChartComposer.variwideChart()
        case 1: return AAColumnVariantChartComposer.columnpyramidChart()
        case 2: return AAColumnVariantChartComposer.dumbbellChart()
        case 3: return AAColumnVariantChartComposer.lollipopChart()
        case 4: return AAColumnVariantChartComposer.xrangeChart()
        case 5: return AAColumnVariantChartComposer.histogramChart()
        case 6: return AAColumnVariantChartComposer.bellcurveChart()
        case 7: return AAColumnVariantChartComposer.bulletChart()
        case 8: return AAColumnVariantChartComposer.invertedXrangeChart()
        case 9: return AAPictorialChartComposer.pictorial1Chart()
        case 10: return AAPictorialChartComposer.pictorial2Chart()
        default: return nil
        }
    }


}
