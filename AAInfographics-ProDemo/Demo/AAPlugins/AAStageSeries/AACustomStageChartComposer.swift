//
//  AACustomStageChartComposer.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/8/19.
//

import Foundation

/// 自定义阶段图表配置组合器
/// 负责创建和配置睡眠阶段图表的所有选项
class AACustomStageChartComposer {
    
    // MARK: - Properties
    
    /// 图表类型
    private static let chartTypeCustomStage = "customstage"

    /// 睡眠阶段类别
    private static let categories = ["Deep", "Core", "REM", "Awake"]
    
    /// 阶段对应的颜色
    private static let stageColors = ["#35349D", "#3478F6", "gold", "red"]
    
    /// 默认图表选项
    public static var defaultOptions = initStageChartOptions()
    
    
    // MARK: - Public Methods
    
    static func initStageChartOptions() -> AAOptions {
        // 默认的睡眠数据（对应 HTML 中的 ECHARTS_DATASET）
        let dataset = [
            ["2024-09-07 06:12", "2024-09-07 06:12", "Awake"],
            ["2024-09-07 06:15", "2024-09-07 06:18", "Awake"],
            ["2024-09-07 08:59", "2024-09-07 09:00", "Awake"],
            ["2024-09-07 05:45", "2024-09-07 06:12", "REM"],
            ["2024-09-07 07:37", "2024-09-07 07:56", "REM"],
            ["2024-09-07 08:56", "2024-09-07 08:59", "REM"],
            ["2024-09-07 09:08", "2024-09-07 09:29", "REM"],
            ["2024-09-07 03:12", "2024-09-07 03:27", "Core"],
            ["2024-09-07 04:02", "2024-09-07 04:36", "Core"],
            ["2024-09-07 04:40", "2024-09-07 04:48", "Core"],
            ["2024-09-07 04:57", "2024-09-07 05:45", "Core"],
            ["2024-09-07 06:12", "2024-09-07 06:15", "Core"],
            ["2024-09-07 06:18", "2024-09-07 07:37", "Core"],
            ["2024-09-07 07:56", "2024-09-07 08:56", "Core"],
            ["2024-09-07 09:00", "2024-09-07 09:08", "Core"],
            ["2024-09-07 09:29", "2024-09-07 10:41", "Core"],
            ["2024-09-07 03:27", "2024-09-07 04:02", "Deep"],
            ["2024-09-07 04:36", "2024-09-07 04:40", "Deep"],
            ["2024-09-07 04:48", "2024-09-07 04:57", "Deep"]
        ]
        
        // 系列数据
        let seriesData = buildSeriesData(from: dataset)
        let series = createSeriesConfig(data: seriesData)
        
        let aaOptions = AAOptions()
            // 基本图表配置
            .chart(createChartConfig())
            // 标题配置
            .title(createTitleConfig())
            // X轴配置（时间轴）
            .xAxis(createXAxisConfig())
            // Y轴配置（类别轴）
            .yAxis(createYAxisConfig())
            // 图例配置
            .legend(createLegendConfig())
            // 提示框配置
            .tooltip(createTooltipConfig())
            // 绘图选项
            .plotOptions(createPlotOptionsConfig(envelope: createEnvelopeConfig(), barRadius: 12.0))
            // 系列数据
            .series([series])
        
        return aaOptions
    }
    
    /// 更新自定义阶段图表的 AAOptions 配置
    /// - Parameters:
    ///   - dataset: 睡眠数据集，格式为 [["开始时间", "结束时间", "阶段"], ...]
    ///   - envelope: 包络层配置
    ///   - barRadius: 条形图圆角半径
    /// - Returns: 配置好的 AAOptions 对象
    static func updateStageChartOptions(
        dataset: [[String]],
        envelope: AAEnvelope,
        barRadius: Float = 12.0
    ) -> AAOptions {
        // 系列数据
        let seriesData = buildSeriesData(from: dataset)
        let series = createSeriesConfig(data: seriesData)
        
        let newOptions = defaultOptions
        
        newOptions
            .plotOptions(createPlotOptionsConfig(envelope: envelope, barRadius: barRadius))
            .series([series])
        
        return newOptions
    }
    
    /// 创建包络层配置
    /// - Parameters:
    ///   - mode: 模式 ("connect" 或 "dilate")
    ///   - arcsEnabled: 是否启用弧形
    ///   - arcsMode: 弧形模式 ("convex" 或 "concave")
    ///   - margin: 边距
    ///   - externalRadius: 外部半径
    ///   - opacity: 透明度
    ///   - seamEpsilon: 缝隙参数
    ///   - fixedGradient: 是否使用固定渐变
    /// - Returns: 配置好的 AAEnvelope 对象
    static func createEnvelopeConfig(
        mode: String = "connect",
        arcsEnabled: Bool = true,
        arcsMode: String = "concave",
        margin: Float = 8.0,
        externalRadius: Float = 18.0,
        opacity: Float = 0.38,
        seamEpsilon: Float = 0.5,
        fixedGradient: Bool = true
    ) -> AAEnvelope {
        let shadow = AAShadow()
            .color("rgba(60, 130, 245, 0.22)")
            .offsetX(0)
            .offsetY(2)
            .opacity(0.55)
            .width(12)
        
        let envelope = AAEnvelope()
            .mode(mode)
            .arcs(arcsEnabled)
            .arcsMode(arcsMode)
            .gapConnect(14)
            .margin(margin)
            .externalRadius(externalRadius)
            .opacity(opacity)
            .seamEpsilon(seamEpsilon)
            .connectorTrim(Float(max(1, Int(externalRadius * 0.6))))
            .shadow(shadow)
        
        if fixedGradient {
            envelope.color = AAGradientColor.linearGradient(
                direction: .toTop,
                stops: [
                    [0.0, "rgba(150, 200, 255, 0.95)"],
                    [0.5, "rgba(90, 160, 255, 0.85)"],
                    [1.0, "rgba(70, 140, 250, 0.80)"]
                ]
            )
         } else {
             envelope.color = "auto"
         }
        
        return envelope
    }
    
    // MARK: - Private Helper Methods
    
    /// 创建图表基本配置
    private static func createChartConfig() -> AAChart {
        return AAChart()
            .type(chartTypeCustomStage)
            .backgroundColor("#ffffff")
    }
    
    /// 创建标题配置
    private static func createTitleConfig() -> AATitle {
        return AATitle()
            .text("Sleep Stages with Envelope")
            .style(AAStyle().fontSize(16).fontWeight(.bold))
    }
    
    /// 创建X轴配置
    private static func createXAxisConfig() -> AAXAxis {
        return AAXAxis()
            .type(.datetime)
            .tickInterval(3600 * 1000) // 1小时间隔
            .gridLineWidth(1)
            .gridLineDashStyle(.shortDash)
            .labels(AALabels()
                .align(.left)
                .format("{value:%H:%M}")
                .style(AAStyle().color("#c6c6c6")))
    }
    
    /// 创建Y轴配置
    private static func createYAxisConfig() -> AAYAxis {
        return AAYAxis()
            .type(.category)
            .categories(categories)
            .title(AATitle().text(""))
            .gridLineWidth(1)
            .labels(AALabels()
                .style(AAStyle()
                    .color("#64748b")
                    .fontSize(12)))
    }
    
    /// 创建图例配置
    private static func createLegendConfig() -> AALegend {
        return AALegend()
            .enabled(true)
    }
    
    /// 创建提示框配置
    private static func createTooltipConfig() -> AATooltip {
        return AATooltip()
            .enabled(true)
            .shadow(true)
            .useHTML(true)
            .formatter("""
                function() {
                    var fmt = function(ts) { return Highcharts.dateFormat('%H:%M', ts); };
                    return '<div><b>' + this.series.yAxis.categories[this.point.y] + '</b><br/>' + 
                           fmt(this.point.x) + ' - ' + fmt(this.point.x2) + '</div>';
                }
            """)
    }
    
    /// 创建绘图选项配置
    private static func createPlotOptionsConfig(envelope: AAEnvelope, barRadius: Float) -> AAPlotOptions {
        return AAPlotOptions()
            .series(AASeries()
                .pointPadding(0)
                .groupPadding(0)
                .colorByPoint(false)
                .envelope(envelope)
                .states(AAStates()
                    .hover(AAHover().enabled(true)))
                .dataLabels(AADataLabels().enabled(false)))
    }
    
    /// 创建系列配置
    private static func createSeriesConfig(data: [[String: Any]]) -> AASeriesElement {
        return AASeriesElement()
            .type(chartTypeCustomStage)
            .name("Sleep Stages")
            .data(data)
    }
    
    /// 构建系列数据
    /// - Parameter dataset: 原始数据集
    /// - Returns: 转换后的系列数据
    private static func buildSeriesData(from dataset: [[String]]) -> [[String: Any]] {
        var seriesData: [[String: Any]] = []
        
        for dataPoint in dataset {
            guard dataPoint.count >= 3 else { continue }
            
            let startTimeStr = dataPoint[0]
            let endTimeStr = dataPoint[1]
            let stage = dataPoint[2]
            
            let startTime = dateFromString(startTimeStr)?.timeIntervalSince1970 ?? 0
            let endTime = dateFromString(endTimeStr)?.timeIntervalSince1970 ?? 0
            
            var yIndex = 0
            var color = stageColors[0]
            
            if let index = categories.firstIndex(of: stage) {
                yIndex = index
                color = stageColors[index]
            }
            
            let dataItem: [String: Any] = [
                "x": startTime * 1000, // Highcharts使用毫秒
                "x2": endTime * 1000,
                "y": yIndex,
                "color": color
            ]
            
            seriesData.append(dataItem)
        }
        
        return seriesData
    }
    
    /// 从字符串解析日期
    /// - Parameter dateString: 日期字符串，格式为 "yyyy-MM-dd HH:mm"
    /// - Returns: Date 对象
    private static func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: dateString)
    }
}

// MARK: - Preset Configurations

extension AACustomStageChartComposer {
    
    /// 预设配置枚举
    enum PresetType {
        case fluid
        case parity
        case safeDilate
        case ultraCrisp
    }
    
    /// 获取预设的包络层配置
    /// - Parameter preset: 预设类型
    /// - Returns: 配置好的 AAEnvelope 对象
    static func createPresetEnvelopeConfig(_ preset: PresetType) -> AAEnvelope {
        switch preset {
        case .fluid:
            return createEnvelopeConfig(
                mode: "connect",
                arcsEnabled: true,
                arcsMode: "concave",
                margin: 8.0,
                externalRadius: 18.0,
                opacity: 0.38,
                seamEpsilon: 0.5,
                fixedGradient: true
            )
        case .parity:
            return createEnvelopeConfig(
                mode: "connect",
                arcsEnabled: false,
                margin: 10.0,
                externalRadius: 24.0,
                opacity: 0.45,
                seamEpsilon: 1.0,
                fixedGradient: true
            )
        case .safeDilate:
            return createEnvelopeConfig(
                mode: "dilate",
                arcsEnabled: false,
                margin: 10.0,
                externalRadius: 16.0,
                opacity: 0.42,
                seamEpsilon: 0.6,
                fixedGradient: true
            )
        case .ultraCrisp:
            return createEnvelopeConfig(
                mode: "connect",
                arcsEnabled: false,
                margin: 5.0,
                externalRadius: 2.0,
                opacity: 0.38,
                seamEpsilon: 0.0,
                fixedGradient: true
            )
        }
    }
}
