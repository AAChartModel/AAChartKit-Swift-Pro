# AAInfographics-Pro 
AAInfographics 的进阶 Pro 版本

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
