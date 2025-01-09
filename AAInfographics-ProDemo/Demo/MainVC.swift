//
//  CommonChartViewController.swift
//  AAChartKit-Swift
//
//  Created by An An on 2017/5/23.
//  Copyright © 2017年 An An . All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 *********************************************************************************
 *
 *  🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit-Swift/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/12302132/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 *********************************************************************************
 
 */

import UIKit


class MainVC: UIViewController {
    private var sectionTitleArr = [
        "RelationshipChart | 关系类型图表",
        "HeatOrTreeMapChart | 热力或树形类型图表",
        "BubbleChart | 气泡类型图表",
        "ColumnVariantChart | 柱形图(变体)类型图表",
        "MoreProType | 更多高级类型图表",
        "Custom Event | 自定义交互事件",
        "DrilldownChart | 可钻取图表",
        "BoostChart | 加速图表",
        "OfficialChartSample | 官方示例",
        "Custom Event2 | 自定义交互事件2",
    ]
    private var chartTypeNameArr = [
        // "RelationshipChart | 关系类型图表",
        [
            "sankeyChart---桑基图",
            "dependencywheelChart---和弦图🎸",
            "arcdiagramChart1---弧形图1🌈",
            "arcdiagramChart2---弧形图2🌈",
            "arcdiagramChart3---弧形图3🌈",
            "organizationChart---组织结构图",
            "networkgraphChart---力导关系图✢✣✤✥",
            "simpleDependencyWheelChart---简单的和弦图🎵",
        ],
        // "HeatOrTreeMapChart | 热力或树形类型图表",
        [
            "heatmapChart---热力图🌡",
            "treemapWithColorAxisData---包好色彩轴的矩形树图🌲",
            "treemapWithLevelsData---包含等级的矩形树图🌲",
            "drilldownLargeDataTreemapChart---可下钻的大数据量矩形树图🌲",
            "largeDataHeatmapChart---大数据量热力图🌡",

            "simpleTilemapWithHexagonTileShape---简单的砖块图🧱(六边形蜂巢图🐝)",
            "simpleTilemapWithCircleTileShape---简单的砖块图🧱(圆形)",
            "simpleTilemapWithDiamondTileShape---简单的砖块图🧱(菱形)",
            "simpleTilemapWithSquareTileShape---简单的砖块图🧱(正方形)",

            "tilemapForAfricaWithHexagonTileShape---非洲砖块图🧱(六边形蜂巢图🐝)",
            "tilemapForAfricaWithCircleTileShape---非洲砖块图🧱(圆形)",
            "tilemapForAfricaWithDiamondTileShape---非洲砖块图🧱(菱形)",
            "tilemapForAfricaWithSquareTileShape---非洲砖块图🧱(正方形)",

            "tilemapForAmericaWithHexagonTileShape---美洲砖块图🧱(六边形蜂巢图🐝)",
            "tilemapForAmericaWithCircleTileShape---美洲砖块图🧱(圆形)",
            "tilemapForAmericaWithDiamondTileShape---美洲砖块图🧱(菱形)",
            "tilemapForAmericaWithSquareTileShape---美洲砖块图🧱(正方形)",

        ],
        // "BubbleChart | 气泡类型图表",
        [
            "packedbubbleChart---气泡填充图🎈",
            "packedbubbleSplitChart---圆堆积图🎈",
            "packedbubbleSpiralChart---渐进变化的气泡图🎈",
            "eulerChart---欧拉图",
            "vennChart---韦恩图",
        ],
        // "ColumnVariantChart | 柱形图(变体)类型图表",
        [
            "variwideChart---可变宽度的柱形图",
            "columnpyramidChart---角锥柱形图",
            "dumbbellChart---哑铃图",
            "lollipopChart---棒棒糖🍭图",
            "xrangeChart---X轴范围图||甘特图||条码图",
            "histogramChart---直方混合散点图📊",
            "bellcurveChart---钟形曲线混合散点图🔔",
            "bulletChart---子弹图"
        ],
        // "MoreProType | 更多高级类型图表",
        [
            "sunburstChart---旭日图🌞",
            "streamgraphChart---流图🌊",
            "vectorChart---向量图🏹",
            "bellcurveChart---贝尔曲线图",
            "timelineChart---时序图⌚️",
            "itemChart---议会项目图🀙🀚🀜🀞🀠🀡",
            "windbarbChart---风羽图🌪️",
            "wordcloudChart---词云图☁️",
            "flameChart---火焰图🔥",
            "itemChart2---议会项目图2🀙🀚🀜🀞🀠🀡",
            "itemChart3---议会项目图3🀙🀚🀜🀞🀠🀡",
            "icicleChart---冰柱图🧊",
            "sunburstChart2---旭日图☀️",
            "solidgaugeChart---活动图🏃🏻‍♀️",
            "parallelCoordinatesSplineChart---平行坐标曲线图",
            "parallelCoordinatesLineChart---平行坐标折线图📈",
            "volinPlotChart---小提琴图🎻",
            "variablepieChart---可变宽度的饼图🍪",
            "semicircleSolidGaugeChart---半圆形活动图🏃🏻‍♀️",
        ],
        // "Custom Event---自定义交互事件",
        [
            "Custom Event---自定义交互事件",
        ],
        // "DrilldownChart---可钻取图表",
        [
            "columnChart---柱形图",
        ],
        // "BoostChart---加速图表",
        [
            //            case 0: return [AABoostChartComposer lineChart];
            //            case 1: return [AABoostChartComposer areaChart];
            //            case 2: return [AABoostChartComposer columnChart];
            "lineChart---折线图",
            "areaChart---区域填充图",
            "columnChart---柱形图",
            "scatterChartWith1MillionPoints---散点图(100万数据量)",
        ],
        // "OfficialChartSample---官方示例",
        [
            "columnChart---柱形图",
        ],
        // "Custom Event2---自定义交互事件2",
        [
            "Custom Event2---自定义交互事件2",
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AAInfographics-Pro"
        view.backgroundColor = .white
        setUpMainTableView()
    }
    
    private func setUpMainTableView() {
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = 45
        tableView.sectionHeaderHeight = 45
        view.addSubview(tableView)
    }
    
    private func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
        return UIColor(
            red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
            green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
            blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
            alpha: 1.0
        )
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chartTypeNameArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartTypeNameArr[section].count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var listTitles = [String]()
        for item: String in sectionTitleArr {
            let titleStr = item.prefix(1)
            listTitles.append(String(titleStr))
        }
        return listTitles
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView()
        sectionHeaderView.backgroundColor = kRGBColorFromHex(rgbValue: 0xF5F5F5)//白烟
        
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.frame = sectionHeaderView.bounds
        sectionTitleLabel.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        sectionTitleLabel.text = sectionTitleArr[section]
        sectionTitleLabel.textColor =  kRGBColorFromHex(rgbValue: 0x7B68EE)//熏衣草花の淡紫色
        sectionTitleLabel.font = .boldSystemFont(ofSize: 17)
        sectionTitleLabel.textAlignment = .center
        sectionHeaderView.addSubview(sectionTitleLabel)
        
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        
        let cellTitle = chartTypeNameArr[indexPath.section][indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = cellTitle
        cell?.textLabel?.font = .systemFont(ofSize: 16)
        cell?.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = AARelationshipChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = AAHeatOrTreeMapChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AABubbleChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = AAColumnVariantChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = ChartProVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = CustomClickEventCallbackMessageVC()
            navigationController?.pushViewController(vc, animated: true)
            
        case 6:
            let vc = AADrilldownChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
            
        case 7:
            let vc = AABoostChartVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
            
        case 8:
            let vc = OfficialChartSampleVC()
//            vc.selectedIndex = indexPath.row
//            vc.navigationItemTitleArr = chartTypeNameArr[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
            
        case 9:
            let vc = CustomClickEventCallbackMessageVC2()
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    
    
}
