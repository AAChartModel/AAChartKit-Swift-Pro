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
 * StackOverflow : https://stackoverflow.com/users/7842508/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 *********************************************************************************
 
 */

import UIKit


class MainVC: UIViewController {
    private var sectionTitleArr = [String]()
    private var chartTypeTitleArr = [[String]]()
    private var chartTypeArr = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AAInfographics"
        
        sectionTitleArr = [
            "Pro Type Chart---高级类型图表",
        ]
        
        chartTypeTitleArr = [
            ["sankeyChart---桑基图",
             "variablepieChart---可变宽度的饼图",
             "treemapChart---树形图",
             "variwideChart---可变宽度的柱形图",
             "sunburstChart---旭日图",
             "dependencywheelChart---和弦图",
             "heatmapChart---热力图",
             "packedbubbleChart---气泡填充图",
             "packedbubbleSplitChart---圆堆积图",
             "vennChart---韦恩图",
             "dumbbellChart---哑铃图",
             "lollipopChart---棒棒糖🍭图",
             "streamgraphChart---流图",
             "columnpyramidChart---角锥柱形图",
             "tilemapChart---砖块图🧱||蜂巢图🐝",
             "simpleTreemapChart---简单矩形树🌲图",
             "drilldownTreemapChart---可下钻的矩形树🌲图",
             "xrangeChart---X轴范围图||甘特图||条码图",
             "vectorChart---向量图🏹",
             "bellcurveChart---贝尔曲线图",
             "timelineChart---时序图⌚️",
             "itemChart---议会项目图",
             "windbarbChart---风羽图",
             "networkgraphChart---力导关系图",
             "wordcloudChart---词云图",
             "eulerChart---欧拉图",
            ],
        
        ]
        
        chartTypeArr = [
            [//Empty Array,just for holding place
            ],
           
        ]
        
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
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chartTypeTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartTypeTitleArr[section].count
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
        
        let cellTitle = chartTypeTitleArr[indexPath.section][indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = cellTitle
        cell?.textLabel?.font = .systemFont(ofSize: 16)
        cell?.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = ChartProVC()
            vc.selectedIndex = indexPath.row
            vc.navigationItemTitleArr = self.chartTypeTitleArr[0]
            navigationController?.pushViewController(vc, animated: true)
       
        default:
            break
        }
    }
    
}
