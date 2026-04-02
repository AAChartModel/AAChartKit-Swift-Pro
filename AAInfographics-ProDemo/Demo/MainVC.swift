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
    @State private var colorSchemeOverride: ColorScheme? = nil
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        let resolvedScheme = colorSchemeOverride ?? systemColorScheme
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    MainContent(sections: sections)
                        .navigationTitle("AAInfographics-Pro")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                ModeToggleButton(colorSchemeOverride: $colorSchemeOverride)
                            }
                        }
                }
            } else {
                NavigationView {
                    MainContent(sections: sections)
                        .navigationBarTitle("AAInfographics-Pro")
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ModeToggleButton(colorSchemeOverride: $colorSchemeOverride)
                    }
                }
            }
        }
        .environment(\.colorScheme, resolvedScheme)
        .preferredColorScheme(colorSchemeOverride)
    }
}

private struct MainContent: View {
    let sections: [ChartSection]
    @State private var activeRoute: MainRoute?

    private static let accentPalette: [Int] = [
        0x5470c6,
        0x91cc75,
        0xfac858,
        0xee6666,
        0x73c0de,
        0x3ba272,
        0xfc8452,
        0x9a60b4,
        0xea7ccc,
        0x5470c6,
        0x91cc75,
        0xfac858,
        0xee6666,
        0x73c0de,
        0x3ba272,
        0xfc8452,
        0x9a60b4,
        0xea7ccc,
    ]

    private var listSections: [AASectionedListSection] {
        sections.enumerated().map { sectionIndex, section in
            let accentColor = Color(
                hex: Self.accentPalette[sectionIndex % Self.accentPalette.count]
            )
            let items = section.items.enumerated().map { itemIndex, item in
                AASectionedListItem(
                    id: AnyHashable(IndexPath(row: itemIndex, section: sectionIndex)),
                    title: item.title,
                    subtitle: "Chart Example #\(itemIndex + 1)",
                    badgeText: "\(itemIndex + 1)"
                )
            }

            return AASectionedListSection(
                id: AnyHashable(sectionIndex),
                title: section.title,
                accentColor: accentColor,
                items: items
            )
        }
    }

    var body: some View {
        ZStack {
            AASectionedListView(sections: listSections) { selection in
                let item = sections[selection.sectionIndex].items[selection.itemIndex]
                activeRoute = MainRoute(destination: item.destination)
            }

            NavigationLink(
                destination: routeDestination,
                isActive: activeRouteBinding,
                label: { EmptyView() }
            )
            .hidden()
        }
    }

    private var activeRouteBinding: Binding<Bool> {
        Binding(
            get: { activeRoute != nil },
            set: { isActive in
                if !isActive {
                    activeRoute = nil
                }
            }
        )
    }

    @ViewBuilder
    private var routeDestination: some View {
        if let activeRoute {
            ViewControllerHost(builder: activeRoute.destination)
                .ignoresSafeArea()
        } else {
            EmptyView()
        }
    }
}

private struct MainRoute {
    let destination: () -> UIViewController
}

private struct ChartSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [ChartItem]

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
            "Options3DChart | 3D图表",
            "Gallery | 画廊",
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
                "neuralNetworkChart---神经网络图",
                "carnivoraPhylogenyOrganizationChart---食肉目动物系统发育组织图",
                "germanicLanguageTreeChart---日耳曼语系树图",
                "sankeyDiagramChart---桑基图(能源流向)",
                "verticalSankeyChart---垂直桑基图",
            ],
            [
                "heatmapChart---热力图🌡",
                "largeDataHeatmapChart---大数据量热力图🌡",
                "calendarHeatmap---日历热力图🗓",
                "treemapWithColorAxisData---包好色彩轴的矩形树图🌲",
                "treemapWithLevelsData---包含等级的矩形树图🌲",
                "treemapWithLevelsData2---包含等级的矩形树图2🌲",
                "drilldownLargeDataTreemapChart---可下钻的大数据量矩形树图🌲",
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
                "treegraphChart---树图🌲",
                "invertedTreegraphChart---倒置树图🌲",
                "treegraphWithBoxLayoutChart---盒布局树图🌲",
            ],
            [
                "packedbubbleChart---气泡填充图🎈",
                "packedbubbleSplitChart---圆堆积图🎈",
                "packedbubbleSpiralChart---渐进变化的气泡图🎈",
                "eulerChart---欧拉图",
                "vennChart---韦恩图",
                "vennChart2---韦恩图2",
                "eulerChart2---欧拉图2",
                "bubbleStellarChart---极坐标行星气泡图🪐",
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
                "lineChartWithHundredsOfSeries---多序列折线图",
                "scatterChartOptions---高密度散点图",
                "areaRangeChart---区域范围图",
                "columnRangeChart---柱形范围图",
                "bubbleChart---气泡图",
                "heatMapChart---热力图",
                "stackingAreaChart---堆积面积图",
                "stackingColumnChart---堆积柱形图",
            ],
            [
                "_3DColumnWithStackingRandomData---3D堆积随机柱形图",
                "_3DColumnWithStackingAndGrouping---3D分组堆积柱形图",
                "_3DBarWithStackingRandomData---3D堆积随机条形图",
                "_3DBarWithStackingAndGrouping---3D分组堆积条形图",
                "_3DAreaChart---3D区域图",
                "_3DScatterChart---3D散点图",
                "_3DPieChart---3D环形饼图",
            ],
            [
                "UITableView 画廊",
                "UICollectionView 画廊",
            ],
            [
                "OfficialChartSample---官方示例网格",
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
                items = makeIndexedItems(names) { selectedIndex, navigationTitles in
                    let vc = AAOptions3DChartVC()
                    vc.selectedIndex = selectedIndex
                    vc.navigationItemTitleArr = navigationTitles
                    return vc
                }
            case 9:
                items = names.enumerated().map { row, title in
                    ChartItem(title: title) {
                        row == 0 ? ProChartTableGalleryVC() : ProChartCollectionGalleryVC()
                    }
                }
            case 10:
                items = names.map { title in
                    ChartItem(title: title) {
                        OfficialChartSampleVC()
                    }
                }
            case 11:
                items = names.map { title in
                    ChartItem(title: title) {
                        FractalChartListVC()
                    }
                }
            case 12:
                items = names.map { title in
                    ChartItem(title: title) {
                        CustomClickEventCallbackMessageVC2()
                    }
                }
            case 13:
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
    @Environment(\.colorScheme) private var colorScheme

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = builder()
        viewController.overrideUserInterfaceStyle = uiStyle(for: colorScheme)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let targetStyle = uiStyle(for: colorScheme)
        if uiViewController.overrideUserInterfaceStyle != targetStyle {
            uiViewController.overrideUserInterfaceStyle = targetStyle
        }
    }

    private func uiStyle(for scheme: ColorScheme) -> UIUserInterfaceStyle {
        switch scheme {
        case .dark:
            return .dark
        case .light:
            return .light
        @unknown default:
            return .unspecified
        }
    }
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

private struct ModeToggleButton: View {
    @Binding var colorSchemeOverride: ColorScheme?
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        Button(action: toggleMode) {
            ZStack {
                Circle()
                    .fill(buttonGradient)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    )
                    .shadow(color: buttonShadow, radius: 8, x: 0, y: 4)

                Image(systemName: currentScheme == .dark ? "sun.max.fill" : "moon.stars.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.white)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(currentScheme == .dark ? "切换为日间模式" : "切换为夜间模式")
        .accessibilityHint("在应用内直接切换外观模式")
    }

    private var currentScheme: ColorScheme {
        colorSchemeOverride ?? systemColorScheme
    }

    private var buttonGradient: LinearGradient {
        if currentScheme == .dark {
            return LinearGradient(colors: [Color(hex: 0xFACC15), Color(hex: 0xF97316)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        return LinearGradient(colors: [Color(hex: 0x6366F1), Color(hex: 0xEC4899)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var buttonShadow: Color {
        currentScheme == .dark ? Color.black.opacity(0.45) : Color.black.opacity(0.2)
    }

    private func toggleMode() {
        colorSchemeOverride = currentScheme == .dark ? .light : .dark
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
