//
//  IdealRangePoint.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/6/3.
//

import Foundation


class AAMixedChartComposer {
    
    static func barMixedColumnrangeWithPatternFillChart() -> AAOptions {
        // 为理想睡眠区间定义深色（用于图案和装饰线）
        let darkerColors = ["#603EAC", "#7560B1", "#4390AD", "#AF8D0E"] // 预先计算的深色(比实际睡眠的棱柱颜色稍微深一些)
        let darkerColorsJsArr = darkerColors.aa_toJSArray() // darkerColors 数组转换为 JavaScript 数组字符串

        // 理想区间原始数据
        let idealRangeRawData: [[String: Any]] = [
            ["low": 20, "high": 32, "x": 0, "category": "深睡", "patternColor": darkerColors[0]],
            ["low": 40, "high": 60, "x": 1, "category": "浅睡", "patternColor": darkerColors[1]],
            ["low": 10, "high": 25, "x": 2, "category": "REM", "patternColor": darkerColors[2]],
            ["low": 0, "high": 5, "x": 3, "category": "清醒", "patternColor": darkerColors[3]]
        ]

        var categories: [String] = []
        for item in idealRangeRawData {
            if let category = item["category"] as? String {
                categories.append(category)
            }
        }

        // 准备 Highcharts 系列数据：理想区间（自定义 Pattern 带图案的条形）
        var idealRangeSeriesData: [[String: Any]] = []
        for d in idealRangeRawData {
            idealRangeSeriesData.append([
                "low": d["low"]!,
                "high": d["high"]!,
                "x": d["x"]!,
                "color": "url(#customPattern\(d["x"]!))" // 使用图案填充
            ])
        }

        // 准备哑铃装饰线（顶部和底部）的数据
        let decorativeCapWidth = 0.40 // 装饰线沿值轴的"宽度/厚度"（视觉上像一条线）
        var topCapsData: [[String: Any]] = []
        var bottomCapsData: [[String: Any]] = []

        for d in idealRangeRawData {
            let high = Double(d["high"] as! Int)
            let low = Double(d["low"] as! Int)
                    
            
            topCapsData.append([
                "x": d["x"]!,
                "low": high - decorativeCapWidth / 2,
                "high": high + decorativeCapWidth / 2,
                "color": d["patternColor"]! // 装饰线的纯色填充
            ])
            bottomCapsData.append([
                "x": d["x"]!,
                "low": low - decorativeCapWidth / 2,
                "high": low + decorativeCapWidth / 2,
                "color": d["patternColor"]! // 装饰线的纯色填充
            ])
        }

        let mainBarPointWidth: Float = 20 // 主图案条和实际睡眠条的"厚度"（倒置图中的高度）
        // 定义装饰线的"高度"（在倒置图中为沿着类别轴的长度/宽度）
        let decorativeCapHeight: Float = 32 // 您可以在此处自定义装饰线的高度，例如 mainBarPointWidth * 1.6

        let aaOptions = AAOptions()

        // 创建 chart 配置
        let chart = AAChart()
            .type(AAChartType.columnrange) // 默认类型，可被系列覆盖
            .inverted(true) // 使图表水平显示
            .events(AAChartEvents()
                .load("""
                function () {
                    const chart = this;
                    const renderer = chart.renderer;
                    let defs = renderer.defs;
                    if (!defs) {
                        defs = renderer.createElement('defs').add();
                        renderer.defs = defs;
                    }
                
                    \(darkerColorsJsArr).forEach((c, i) => {
                        defs.element.innerHTML += `
                            <pattern id="customPattern${i}"
                                     patternUnits="userSpaceOnUse"
                                     width="6" height="6">
                              <path d="M 0 0 L 6 6"
                                    stroke="${c}"
                                    stroke-width="1.5"/>
                            </pattern>`;
                    });
                }
                """)
            )

        // 创建 title 配置
        let title = AATitle()
            .text("睡眠阶段 vs 理想区间")

        // 创建 xAxis 配置
        let xAxis = AAXAxis()
            .categories(categories)
            // 如果希望 '深睡' 在底部，则设置为 true (原 JS 中为 xAxis: { categories: categories, reversed: true })

        // 创建 yAxis 配置
        let yAxis = AAYAxis()
            .min(0)             // 显式设置 Y 轴最小值
            .max(100)
            .title(AATitle()
                .text(nil))
            .gridLineWidth(1)
            .tickInterval(10)    // 可选：设置 Y 轴刻度间隔

        // 创建 plotOptions 配置
        let plotOptions = AAPlotOptions()
            .series(AASeries() // 新增：全局禁用所有系列的 hover 状态
                .states(AAStates()
                    .hover(AAHover()
                        .enabled(false)
                    )
                )
            )
            .columnrange(AAColumnrange()
                .grouping(false)     // 允许系列重叠
                .groupPadding(0.15)  // 调整类别间的整体间距
                .pointPadding(0.1)   // 影响其槽内柱子计算出的宽度
                .borderWidth(0)
                .dataLabels(AADataLabels()
                    .enabled(false)
                )
            )
            .bar(AABar() // Specific options for bar series if needed, for consistency
                .grouping(false)     // Also allow bar series to overlap
                .borderWidth(0)
            )

        // 创建 legend 配置
        let legend = AALegend()
            .enabled(true)

        // 创建 tooltip 配置
        let tooltip = AATooltip()
            .shared(true)
            .formatter("""
                function() {
                    let s = `<b>${this.points[0].series.xAxis.categories[this.x]}</b>`; 
                    this.points.forEach(point => {
                        if (point.series.name === '理想睡眠区间') {
                            s += `<br/><span style="color:${point.point.color.pattern.color}">●</span> ${point.series.name}: ${point.point.low} - ${point.point.high}`;
                        } else if (point.series.name === '实际睡眠') {
                            s += `<br/><span style="color:${point.color}">●</span> ${point.series.name}: ${point.y} (${point.point.label || point.y + '%'})`;
                        }
                    });
                    return s;
                }
            """)
        
        // 系列数据
        // 实际睡眠数据 - 中间层
        let actualSleepSeries = AASeriesElement()
            .name("实际睡眠")
            .type(AAChartType.bar) // 'bar' is essentially an inverted 'column'
            .data([
                ["y": 27, "color": "#8B5CF6", "label": "1小时22分钟（27%）"],
                ["y": 53, "color": "#A78BFA", "label": "3小时42分钟（53%）"],
                ["y": 18, "color": "#60CDF5", "label": "1小时49分钟（18%）"],
                ["y": 2,  "color": "#FACC15", "label": "5分钟（2%）"]
            ])
            .pointWidth(mainBarPointWidth) // 设置与理想区间相同的"厚度"
            .dataLabels(AADataLabels()
                .enabled(true)
                .formatter("""
                    function () {
                        return this.point.label;
                    }
                """)
            )
            .zIndex(0) // 绘制在理想区间之下

        let idealRangeSeries = AASeriesElement()
            .name("理想睡眠区间")
            .type(AAChartType.columnrange)
            .data(idealRangeSeriesData)
            .pointWidth(mainBarPointWidth) // 与实际睡眠条具有相同的"厚度"
            .zIndex(1)                     // 绘制在实际睡眠数据上层, 这样视觉效果才能不被覆盖
            .showInLegend(true)

        // 哑铃顶部装饰线 - 最顶层
        let topCapsSeries = AASeriesElement()
            .name("装饰线")
            .type(AAChartType.columnrange)
            .data(topCapsData)
            .pointWidth(decorativeCapHeight)     // 装饰线的"高度" (倒置图中的宽度)
            .zIndex(2)                     // 在主图案条和实际睡眠条之上绘制
            .showInLegend(false)
            .enableMouseTracking(false)
            .clip(false)

        // 哑铃底部装饰线 - 最顶层
        let bottomCapsSeries = AASeriesElement()
            .name("装饰线")
            .type(AAChartType.columnrange)
            .data(bottomCapsData)
            .pointWidth(decorativeCapHeight)     // 装饰线的"高度" - 更宽
            .zIndex(2)
            .showInLegend(false)
            .enableMouseTracking(false)
            .clip(false)

        let seriesArr = [
            actualSleepSeries,
            idealRangeSeries,
            topCapsSeries,
            bottomCapsSeries
        ]
        
        aaOptions.chart = chart
        aaOptions.title = title
        aaOptions.xAxis = xAxis
        aaOptions.yAxis = yAxis
        aaOptions.plotOptions = plotOptions
        aaOptions.legend = legend
        aaOptions.tooltip = tooltip
        aaOptions.series = seriesArr

        return aaOptions
    }
}
