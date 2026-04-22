# AAInfographics-Pro 

AAInfographics-Pro 是 AAInfographics 的进阶专业版，这是一款专为 iOS、iPadOS 和 macOS 设计的优雅的声明式图表框架。作为更强大的数据可视化框架，AAInfographics-Pro 支持更多精美图表类型，包括钟形曲线图、子弹图、柱状金字塔图、圆柱图、依赖关系图、热力图、直方图、网络关系图、组织结构图、聚合气泡图、帕累托图、桑基图系列图表、仪表盘图、流程图、和弦图、树状图、矩形图、概率分布图、向量图、维恩图、风羽图、词云图等多样化图表展示。
## 环境要求

- iOS 13.0+
- macOS 10.13+
- Swift 5
- Swift Package Manager tools 5.3+

## 安装方式

### CocoaPods

```ruby
pod 'AAInfographics-Pro'
```

Swift 中导入模块:

```swift
import AAInfographics_Pro
```

### Swift Package Manager

在 Xcode 的 `Package Dependencies` 中添加:

`https://github.com/AAChartModel/AAChartKit-Swift-Pro.git`

如果你使用 `Package.swift`，可以这样写:

```swift
dependencies: [
    .package(url: "https://github.com/AAChartModel/AAChartKit-Swift-Pro.git", from: "10.0.0")
]
```

然后把 `AAInfographics-Pro` 这个 product 链接到你的 target，并在 Swift 中导入:

```swift
import AAInfographics_Pro
```

> 说明: Swift Package 的 product 名是 `AAInfographics-Pro`，但 Swift 代码里的模块导入名仍然是 `AAInfographics_Pro`，因为 Swift 的 `import` 不能使用 `-`。


### Heat and tree maps

![](https://www.highcharts.com/demo/images/samples/highcharts/demo/heatmap/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/heatmap-canvas/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/treemap-large-dataset/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/honeycomb-usa/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/treemap-coloraxis/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/treemap-with-levels/thumbnail.svg)


## Bubble Charts
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/packed-bubble/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/packed-bubble-split/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/venn-diagram/thumbnail.svg)
![](https://www.highcharts.com/demo/euler-diagram)

## Relationships Charts
![](https://www.highcharts.com/demo/arc-diagram)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/dependency-wheel/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/sankey-diagram/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/network-graph/thumbnail.svg)
![](https://www.highcharts.com/demo/images/samples/highcharts/demo/organization-chart/thumbnail.svg)
