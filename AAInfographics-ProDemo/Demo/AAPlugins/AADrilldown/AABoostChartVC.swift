//
//  AABubbleChartVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/10/15.
//

import Foundation

class AABoostChartVC: AABaseChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"AADrilldown" ofType:@"js"];
         self.aaChartView.pluginsArray = @[jsPath];
         */
        let jsPath: String = Bundle.main.path(forResource: "AABoost", ofType: "js") ?? ""
        self.aaChartView?.userPluginPaths = [jsPath]
        
        //输出查看 AAOption 的 computedProperties 内容
//        AAOptions *aaOptions = [self chartConfigurationWithSelectedIndex:self.selectedIndex];
        let aaOptions: AAOptions = self.chartConfigurationWithSelectedIndex(self.selectedIndex) as! AAOptions
        print("AAOptions 新增的计算属性 computedProperties: \(String(describing: aaOptions.computedProperties()))")


    }

    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        switch (selectedIndex) {
        /**
         case 0: return [AABoostChartComposer lineChart];
         case 1: return [AABoostChartComposer areaChart];
         case 2: return [AABoostChartComposer columnChart];
         */
            
            /**
             //分形曼德尔布罗特图
             class func fractalMandelbrot() -> AAOptions
             
             //分形谢尔宾斯基树图
             class func fractalSierpinskiTreeData() -> AAOptions
             
             //分形谢尔宾斯基三角形图
             class func fractalSierpinskiTriangleData() -> AAOptions
             
             //分形谢尔宾斯基地毯图
             class func fractalSierpinskiCarpetData() -> AAOptions
             */
            
        case 0: return AABoostFractalChartComposer.fractalMandelbrot()
        case 1: return AABoostFractalChartComposer.fractalSierpinskiTreeData()
        case 2: return AABoostFractalChartComposer.fractalSierpinskiTriangleData()
        case 3: return AABoostFractalChartComposer.fractalSierpinskiCarpetData()
            
            
        default: return nil
        }
    }

}

