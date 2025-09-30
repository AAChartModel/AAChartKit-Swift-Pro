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

import SwiftUI

final class MainVC: UIHostingController<MainView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MainView())
    }

    init() {
        super.init(rootView: MainView())
    }
}

struct MainView: View {
    private let sections = ChartSection.defaultSections()

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    MainContent(sections: sections)
                        .navigationTitle("AAInfographics-Pro")
                }
            } else {
                NavigationView {
                    MainContent(sections: sections)
                        .navigationBarTitle("AAInfographics-Pro")
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

private struct MainContent: View {
    let sections: [ChartSection]
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                listView(proxy: proxy)

                if sections.count > 1 {
                    SectionIndexSidebar(sections: sections) { target in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(target.id, anchor: .top)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.trailing, 4)
                }
            }
            .background(Color(.systemBackground))
        }
    }

    @ViewBuilder
    private func listView(proxy: ScrollViewProxy) -> some View {
        let list = List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.items) { item in
                        NavigationLink {
                            ViewControllerHost(builder: item.destination)
                                .ignoresSafeArea()
                        } label: {
                            Text(item.title)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .multilineTextAlignment(.leading)
                        }
                        .listRowBackgroundCompat(Color(.systemBackground))
                    }
                } header: {
                    SectionHeader(title: section.title)
                }
                .textCase(nil)
                .id(section.id)
            }
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))

        if #available(iOS 16.0, *) {
            list
                .scrollContentBackground(.hidden)
        } else {
            list
        }
    }
}

private struct SectionHeader: View {
    let title: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(headerTextColor)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)
            .background(headerBackgroundColor)
    }

    private var headerBackgroundColor: Color {
        if colorScheme == .dark {
            return Color(.secondarySystemBackground)
        }
        return Color(hex: 0xF5F5F5)
    }

    private var headerTextColor: Color {
        if colorScheme == .dark {
            return Color(hex: 0xC3BCFF)
        }
        return Color(hex: 0x7B68EE)
    }
}

private struct SectionIndexSidebar: View {
    let sections: [ChartSection]
    let onSelect: (ChartSection) -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 6) {
            ForEach(sections) { section in
                Button {
                    onSelect(section)
                } label: {
                    Text(section.indexTitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(sidebarBackground())
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private func sidebarBackground() -> some View {
        if #available(iOS 15.0, *) {
            Capsule()
                .fill(Color.clear)
                .background(
                    Capsule()
                        .fill(sidebarTintColor)
                )
        } else {
            Capsule().fill(sidebarFallbackColor)
        }
    }

    private var sidebarFallbackColor: Color {
        if colorScheme == .dark {
            return Color(.systemGray4).opacity(0.65)
        }
        return Color(.systemBackground).opacity(0.8)
    }

    private var sidebarTintColor: Color {
        if colorScheme == .dark {
            return Color(.tertiarySystemBackground).opacity(0.7)
        }
        return Color(.systemBackground).opacity(0.85)
    }
}

private struct ChartSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [ChartItem]

    var indexTitle: String {
        String(title.prefix(1))
    }

    static func defaultSections() -> [ChartSection] {
        let sectionTitles = [
            "RelationshipChart | 关系类型图表",
            "HeatOrTreeMapChart | 热力或树形类型图表",
            "BubbleChart | 气泡类型图表",
            "ColumnVariantChart | 柱形图(变体)类型图表",
            "MoreProType | 更多高级类型图表",
            "Custom Event | 自定义交互事件",
            "DrilldownChart | 可钻取图表",
            "BoostChart | 加速图表",
            "OfficialChartSample | 官方示例",
            "FractalChartListVC | 分形图表列表",
            "Custom Event2 | 自定义交互事件2",
            "AACustomStageChartVC | 自定义分段图"
        ]

        let chartTypeNameArr = [
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
            [
                "packedbubbleChart---气泡填充图🎈",
                "packedbubbleSplitChart---圆堆积图🎈",
                "packedbubbleSpiralChart---渐进变化的气泡图🎈",
                "eulerChart---欧拉图",
                "vennChart---韦恩图",
            ],
            [
                "variwideChart---可变宽度的柱形图",
                "columnpyramidChart---角锥柱形图",
                "dumbbellChart---哑铃图",
                "lollipopChart---棒棒糖🍭图",
                "xrangeChart---X轴范围图||甘特图||条码图",
                "histogramChart---直方混合散点图📊",
                "bellcurveChart---钟形曲线混合散点图🔔",
                "bulletChart---子弹图",
                "inverted xrangeChart---倒转的X轴范围图||甘特图||条码图",
                "pictorial1Chart---象形柱形图1",
                "pictorial2Chart---象形柱形图2",
            ],
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
            [
                "Custom Event---自定义交互事件",
            ],
            [
                "columnChart---柱形图",
            ],
            [
                "lineChart---折线图",
                "areaChart---区域填充图",
                "columnChart---柱形图",
                "scatterChartWith1MillionPoints---散点图(100万数据量)",
            ],
            [
                "columnChart---柱形图",
            ],
            [
                "FractalChartListVC---分形图表列表",
            ],
            [
                "Custom Event2---自定义交互事件2",
            ],
            [
                "AACustomStageChartVC | 自定义分段睡眠💤图",
            ],
        ]

        func makeIndexedItems(_ titles: [String], factory: @escaping (Int, [String]) -> UIViewController) -> [ChartItem] {
            titles.enumerated().map { index, label in
                let navigationTitles = titles
                return ChartItem(title: label) {
                    factory(index, navigationTitles)
                }
            }
        }

        var sections: [ChartSection] = []

        for (index, title) in sectionTitles.enumerated() {
            let names = chartTypeNameArr[index]
            let items: [ChartItem]

            switch index {
            case 0:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AARelationshipChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 1:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AAHeatOrTreeMapChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 2:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AABubbleChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 3:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AAColumnVariantChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 4:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = ChartProVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 5:
                items = names.map { title in
                    ChartItem(title: title) {
                        CustomClickEventCallbackMessageVC()
                    }
                }
            case 6:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AADrilldownChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 7:
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AABoostChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 8:
                items = names.map { title in
                    ChartItem(title: title) {
                        OfficialChartSampleVC()
                    }
                }
            case 9:
                items = names.map { title in
                    ChartItem(title: title) {
                        ChartListTableViewVC()
                    }
                }
            case 10:
                items = names.map { title in
                    ChartItem(title: title) {
                        CustomClickEventCallbackMessageVC2()
                    }
                }
            case 11:
                items = names.map { title in
                    ChartItem(title: title) {
                        AACustomStageChartVC()
                    }
                }
            default:
                items = []
            }

            sections.append(ChartSection(title: title, items: items))
        }

        return sections
    }
}

private struct ChartItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: () -> UIViewController
}

private struct ViewControllerHost: UIViewControllerRepresentable {
    let builder: () -> UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        builder()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

private extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(UIColor(hex: hex, alpha: alpha))
    }
}

private extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

private extension View {
    @ViewBuilder
    func listRowBackgroundCompat(_ color: Color) -> some View {
        if #available(iOS 15.0, *) {
            listRowBackground(color)
        } else {
            self
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
