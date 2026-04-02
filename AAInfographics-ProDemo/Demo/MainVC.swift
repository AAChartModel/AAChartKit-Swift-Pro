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
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                GradientBackground(colorScheme: colorScheme)

                ScrollView {
                    LazyVStack(spacing: 28, pinnedViews: []) {
                        ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                            SectionCard(section: section, index: index)
                                .id(section.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 32)
                }

                if sections.count > 1 {
                    SectionIndexSidebar(sections: sections) { target in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.3)) {
                            proxy.scrollTo(target.id, anchor: .top)
                        }
                    }
                    .padding(.vertical, 32)
                    .padding(.trailing, 6)
                }
            }
        }
    }
}

private struct GradientBackground: View {
    let colorScheme: ColorScheme

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var gradientColors: [Color] {
        if colorScheme == .dark {
            return [Color(hex: 0x0F172A), Color(hex: 0x111827), Color(hex: 0x1F2937)]
        }
        return [Color(hex: 0xF4F7FF), Color(hex: 0xFDF3FF), Color(hex: 0xFEF6F0)]
    }
}

private struct SectionCard: View {
    let section: ChartSection
    let index: Int
    @Environment(\.colorScheme) private var colorScheme

    private var style: SectionCardStyle {
        .palette(for: index)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header

            VStack(spacing: 12) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { itemIndex, item in
                    NavigationLink {
                        ViewControllerHost(builder: item.destination)
                            .ignoresSafeArea()
                    } label: {
                        SectionItemRow(title: item.title, style: style, index: itemIndex)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(cardFillColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(style.borderGradient, lineWidth: 1)
                .opacity(colorScheme == .dark ? 0.35 : 0.55)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: shadowColor, radius: 18, x: 0, y: 14)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(style.accentGradient)
                    .frame(width: 52, height: 52)
                    .shadow(color: style.highlightShadow(colorScheme: colorScheme), radius: 12, x: 0, y: 8)

                Image(systemName: style.iconName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(section.primaryTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(primaryTextColor)

                if let subtitle = section.secondaryTitle {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(secondaryTextColor)
                }
            }

            Spacer(minLength: 12)

            Text("\(section.items.count) 示例")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(chipForegroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(chipBackgroundColor)
                )
        }
    }

    private var cardFillColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.78)
    }

    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.48) : Color.black.opacity(0.12)
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? Color.white : Color(hex: 0x111827)
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color(hex: 0x4B5563)
    }

    private var chipForegroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.85) : Color(hex: 0x1F2937)
    }

    private var chipBackgroundColor: Color {
        let base = style.accentColors.first ?? Color.blue
        return base.opacity(colorScheme == .dark ? 0.35 : 0.2)
    }
}

private struct SectionItemRow: View {
    let title: String
    let style: SectionCardStyle
    let index: Int
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(style.accentGradient)
                .frame(width: 42, height: 42)
                .overlay(
                    Text(displayIndex)
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(Color.white)
                )

            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(rowTextColor)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(rowChevronColor)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(rowBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.2), lineWidth: 0.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: rowShadowColor, radius: 8, x: 0, y: 6)
    }

    private var rowBackgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.6)
    }

    private var rowTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.9) : Color(hex: 0x1F2933)
    }

    private var rowChevronColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.65) : Color.black.opacity(0.35)
    }

    private var rowShadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.35) : Color.black.opacity(0.1)
    }

    private var displayIndex: String {
        index < 9 ? "0\(index + 1)" : "\(index + 1)"
    }
}

private struct SectionCardStyle {
    let accentColors: [Color]
    let iconName: String

    var accentGradient: LinearGradient {
        LinearGradient(colors: accentColors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var borderGradient: LinearGradient {
        LinearGradient(colors: accentColors.map { $0.opacity(0.75) }, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    func highlightShadow(colorScheme: ColorScheme) -> Color {
        let base = accentColors.last ?? .blue
        return base.opacity(colorScheme == .dark ? 0.45 : 0.35)
    }
}

private extension SectionCardStyle {
    static func palette(for index: Int) -> SectionCardStyle {
        let palettes: [SectionCardStyle] = [
            SectionCardStyle(
                accentColors: [Color(hex: 0x60A5FA), Color(hex: 0x34D399)],
                iconName: "point.topleft.down.curvedto.point.bottomright.up"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xF97316), Color(hex: 0xFDE047)],
                iconName: "flame.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xF472B6), Color(hex: 0x8B5CF6)],
                iconName: "circle.grid.3x3.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0x22D3EE), Color(hex: 0x0EA5E9)],
                iconName: "chart.bar.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xA855F7), Color(hex: 0x6366F1)],
                iconName: "waveform.path.ecg.rectangle"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xF87171), Color(hex: 0xFB7185)],
                iconName: "hand.tap.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0x4ADE80), Color(hex: 0x22C55E)],
                iconName: "square.grid.2x2.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0x0EA5E9), Color(hex: 0x6366F1)],
                iconName: "waveform.path.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xF59E0B), Color(hex: 0xF97316)],
                iconName: "chart.pie.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0x2DD4BF), Color(hex: 0x14B8A6)],
                iconName: "tree.fill"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0xFB7185), Color(hex: 0xF472B6)],
                iconName: "hand.tap"
            ),
            SectionCardStyle(
                accentColors: [Color(hex: 0x7C3AED), Color(hex: 0x38BDF8)],
                iconName: "clock.arrow.circlepath"
            )
        ]

        guard !palettes.isEmpty else {
            return SectionCardStyle(
                accentColors: [Color(hex: 0x6366F1), Color(hex: 0xEC4899)],
                iconName: "chart.bar.xaxis"
            )
        }

        return palettes[index % palettes.count]
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
                        .foregroundColor(sidebarTextColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(sidebarBackground)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var sidebarBackground: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: sidebarGradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.25 : 0.4), lineWidth: 0.8)
            )
            .shadow(color: sidebarShadowColor, radius: 6, x: 0, y: 3)
    }

    private var sidebarGradientColors: [Color] {
        if colorScheme == .dark {
            return [Color.white.opacity(0.18), Color.white.opacity(0.07)]
        }
        return [Color.white.opacity(0.92), Color.white.opacity(0.65)]
    }

    private var sidebarShadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.45) : Color.black.opacity(0.18)
    }

    private var sidebarTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.7)
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

private extension ChartSection {
    var primaryTitle: String {
        let pieces = title.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: true)
        guard let first = pieces.first else { return title }
        return first.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var secondaryTitle: String? {
        let pieces = title.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: true)
        guard pieces.count > 1 else { return nil }
        return pieces[1].trimmingCharacters(in: .whitespacesAndNewlines)
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
