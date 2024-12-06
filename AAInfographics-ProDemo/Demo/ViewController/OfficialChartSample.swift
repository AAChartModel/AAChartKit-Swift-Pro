//
//  OfficialChartSample.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/12/6.
//

import SwiftUI

// 封装 AAChartView
struct AAChartViewRepresentable: UIViewRepresentable {
    @Binding var chartOptions: AAOptions
    
    
    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.scrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: AAChartView, context: Context) {
        uiView.aa_drawChartWithChartOptions(chartOptions)
    }
}

// SwiftUI 主视图
struct SwiftUIChartView: View {
    @State private var chartModel = AAChartModel()
        .chartType(.column)
        .title("AAChartView in SwiftUI")
        .subtitle("SwiftUI Integration")
        .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun"])
        .dataLabelsEnabled(true)
        .legendEnabled(false)
        .series([
            AASeriesElement()
                .name("2024")
                .data([3.0, 4.0, 3.0, 5.0, 4.0, 10.0])
        ])
    
    var body: some View {
        VStack {
            AAChartViewRepresentable(chartOptions: Binding.constant(AARelationshipChartComposer.sankeyChart()))
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartOptions: Binding.constant(AARelationshipChartComposer.arcdiagramChart1()))
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartOptions: Binding.constant(AARelationshipChartComposer.dependencywheelChart()))
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartOptions: Binding.constant(AARelationshipChartComposer.organizationChart()))
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartOptions: Binding.constant(AARelationshipChartComposer.arcdiagramChart3()))
                .frame(height: 300) // 设置图表高度
            Button("Update Data") {
                chartModel.series([
                    AASeriesElement()
                        .name("2024")
                        .data([10.0, 20.0, 30.0, 40.0, 50.0, 60.0])
                ])
            }
        }
    }
}


struct GridView: View {
      
    /**
     case 0: return AARelationshipChartComposer.sankeyChart()
     case 1: return AARelationshipChartComposer.dependencywheelChart()
     case 2: return AARelationshipChartComposer.arcdiagramChart1()
     case 3: return AARelationshipChartComposer.arcdiagramChart2()
     case 4: return AARelationshipChartComposer.arcdiagramChart3()
     case 5: return AARelationshipChartComposer.organizationChart()
     case 6: return AARelationshipChartComposer.networkgraphChart()
     case 7: return AARelationshipChartComposer.simpleDependencyWheelChart()
     */
    let optionsItems = [
        AARandomValueDataComposer.configureChartOptions(chartType: .column),          //Column series display one column per value along an X axis.
        AARandomValueDataComposer.configureChartOptions(chartType: .bar),             //A bar series is a special type of column series where the columns are horizontal.
        AARandomValueDataComposer.configureChartOptions(chartType: .area),            //The area series type.
        AARandomValueDataComposer.configureChartOptions(chartType: .areaspline),      //The area spline series is an area series where the graph between the points is smoothed into a spline.
        AARandomValueDataComposer.configureChartOptions(chartType: .line),            //A line series displays information as a series of data points connected by straight line segments.
        AARandomValueDataComposer.configureChartOptions(chartType: .spline),          //A spline series is a special type of line series, where the segments between the data points are smoothed.
        AARandomValueDataComposer.configureChartOptions(chartType: .scatter),         //A scatter plot uses cartesian coordinates to display values for two variables for a set of data.
        AARandomValueDataComposer.configureChartOptions(chartType: .pie),             //A pie chart is a circular graphic which is divided into slices to illustrate numerical proportion.
        AARandomValueDataComposer.configureChartOptions(chartType: .bubble),          //A bubble series is a three dimensional series type where each point renders an X, Y and Z value. Each points is drawn as a bubble where the position along the X and Y axes mark the X and Y values, and the size of the bubble relates to the Z value.
        AARandomValueDataComposer.configureChartOptions(chartType: .pyramid),         //A pyramid series is a special type of funnel, without neck and reversed by default.
        AARandomValueDataComposer.configureChartOptions(chartType: .funnel),          //Funnel charts are a type of chart often used to visualize stages in a sales project, where the top are the initial stages with the most clients. It requires that the modules/funnel.js file is loaded.
        AARandomValueDataComposer.configureChartOptions(chartType: .columnrange),     //The column range is a cartesian series type with higher and lower Y values along an X axis. To display horizontal bars, set chart.inverted to true.
        AARandomValueDataComposer.configureChartOptions(chartType: .arearange),       //The area range series is a carteseian series with higher and lower values for each point along an X axis, where the area between the values is shaded.
        AARandomValueDataComposer.configureChartOptions(chartType: .areasplinerange), //The area spline range is a cartesian series type with higher and lower Y values along an X axis. The area inside the range is colored, and the graph outlining the area is a smoothed spline.
        AARandomValueDataComposer.configureChartOptions(chartType: .boxplot),         //A box plot is a convenient way of depicting groups of data through their five-number summaries: the smallest observation (sample minimum), lower quartile (Q1), median (Q2), upper quartile (Q3), and largest observation (sample maximum).
        AARandomValueDataComposer.configureChartOptions(chartType: .waterfall),       //A waterfall chart displays sequentially introduced positive or negative values in cumulative columns.
        AARandomValueDataComposer.configureChartOptions(chartType: .polygon),         //A polygon series can be used to draw any freeform shape in the cartesian coordinate system. A fill is applied with the color option, and stroke is applied through lineWidth and lineColor options.
        AARandomValueDataComposer.configureChartOptions(chartType: .gauge),           //Gauges are circular plots displaying one or more values with a dial pointing to values along the perimeter.
        AARandomValueDataComposer.configureChartOptions(chartType: .errorbar),        //Error bars are a graphical representation of the variability of data and are used on graphs to indicate the error, or uncertainty in a reported measurement.
        
        
        AARandomValueDataComposer.configureChartOptions(chartType: .sankey),
        AARandomValueDataComposer.configureChartOptions(chartType: .variablepie),
        AARandomValueDataComposer.configureChartOptions(chartType: .treemap),
        AARandomValueDataComposer.configureChartOptions(chartType: .variwide),
        AARandomValueDataComposer.configureChartOptions(chartType: .sunburst),
        AARandomValueDataComposer.configureChartOptions(chartType: .dependencywheel),
        AARandomValueDataComposer.configureChartOptions(chartType: .heatmap),
        AARandomValueDataComposer.configureChartOptions(chartType: .packedbubble),
        AARandomValueDataComposer.configureChartOptions(chartType: .venn),
        AARandomValueDataComposer.configureChartOptions(chartType: .dumbbell),
        AARandomValueDataComposer.configureChartOptions(chartType: .lollipop),
        AARandomValueDataComposer.configureChartOptions(chartType: .streamgraph),
        AARandomValueDataComposer.configureChartOptions(chartType: .columnpyramid),
        AARandomValueDataComposer.configureChartOptions(chartType: .xrange),
        
        AARandomValueDataComposer.configureChartOptions(chartType: .tilemap),
        AARandomValueDataComposer.configureChartOptions(chartType: .vector),
        AARandomValueDataComposer.configureChartOptions(chartType: .bellcurve),
        AARandomValueDataComposer.configureChartOptions(chartType: .timeline),
        AARandomValueDataComposer.configureChartOptions(chartType: .item),
        AARandomValueDataComposer.configureChartOptions(chartType: .windbarb),
        AARandomValueDataComposer.configureChartOptions(chartType: .networkgraph),
        AARandomValueDataComposer.configureChartOptions(chartType: .wordcloud),
        
        AARandomValueDataComposer.configureChartOptions(chartType: .organization),
        AARandomValueDataComposer.configureChartOptions(chartType: .arcdiagram),
        AARandomValueDataComposer.configureChartOptions(chartType: .flame),
        AARandomValueDataComposer.configureChartOptions(chartType: .solidgauge),
        AARandomValueDataComposer.configureChartOptions(chartType: .histogram),
        AARandomValueDataComposer.configureChartOptions(chartType: .bullet),
        
        
        
        
        
        AARelationshipChartComposer.sankeyChart(),
        AARelationshipChartComposer.dependencywheelChart(),
        AARelationshipChartComposer.arcdiagramChart1(),
        AARelationshipChartComposer.arcdiagramChart2(),
        AARelationshipChartComposer.arcdiagramChart3(),
        AARelationshipChartComposer.organizationChart(),
        AARelationshipChartComposer.networkgraphChart(),
        AARelationshipChartComposer.simpleDependencyWheelChart(),
        
        AABubbleChartComposer.packedbubbleChart(),
        AABubbleChartComposer.packedbubbleSplitChart(),
        AABubbleChartComposer.packedbubbleSpiralChart(),
        AABubbleChartComposer.eulerChart(),
        AABubbleChartComposer.vennChart(),
        
        AAColumnVariantChartComposer.variwideChart(),
        AAColumnVariantChartComposer.columnpyramidChart(),
        AAColumnVariantChartComposer.dumbbellChart(),
        AAColumnVariantChartComposer.lollipopChart(),
        AAColumnVariantChartComposer.xrangeChart(),
        AAColumnVariantChartComposer.histogramChart(),
        AAColumnVariantChartComposer.bellcurveChart(),
        AAColumnVariantChartComposer.bulletChart(),
        
        AAHeatOrTreeMapChartComposer.heatmapChart(),
        AAHeatOrTreeMapChartComposer.treemapWithColorAxisData(),
        AAHeatOrTreeMapChartComposer.treemapWithLevelsData(),
        AAHeatOrTreeMapChartComposer.drilldownLargeDataTreemapChart(),
        AAHeatOrTreeMapChartComposer.largeDataHeatmapChart(),
        AAHeatOrTreeMapChartComposer.simpleTilemapWithHexagonTileShape(),
        AAHeatOrTreeMapChartComposer.simpleTilemapWithCircleTileShape(),
        AAHeatOrTreeMapChartComposer.simpleTilemapWithDiamondTileShape(),
        AAHeatOrTreeMapChartComposer.simpleTilemapWithSquareTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapForAfricaWithHexagonTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapForAfricaWithCircleTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapForAfricaWithDiamondTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapForAfricaWithSquareTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithHexagonTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithCircleTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithDiamondTileShape(),
        AAHeatOrTreeMapChartComposer.tilemapChartForAmericaWithSquareTileShape(),
        
        ChartProVC.sunburstChart(),
        ChartProVC.streamgraphChart(),
        ChartProVC.vectorChart(),
        ChartProVC.bellcurveChart(),
        ChartProVC.timelineChart(),
        ChartProVC.itemChart(),
        ChartProVC.windbarbChart(),
        ChartProVC.wordcloudChart(),
        ChartProVC.flameChart(),
        ChartProVC.itemChart2(),
        ChartProVC.itemChart3(),
        ChartProVC.icicleChart(),
        ChartProVC.sunburstChart2(),
        ChartProVC.solidgaugeChart(),
        ChartProVC.parallelCoordinatesSplineChart(),
        ChartProVC.parallelCoordinatesLineChart(),
        ChartProVC.volinPlotChart(),
        ChartProVC.variablepieChart(),
        ChartProVC.semicircleSolidGaugeChart(),
        
        AADrilldownChartComposer.columnChart().pluginsArray([Bundle.main.path(forResource: "AADrilldown", ofType: "js") ?? ""]),
        
        AABoostChartComposer.lineChart().pluginsArray([Bundle.main.path(forResource: "AABoost", ofType: "js") ?? ""]),
        AABoostChartComposer.areaChart().pluginsArray([Bundle.main.path(forResource: "AABoost", ofType: "js") ?? ""]),
        AABoostChartComposer.columnChart().pluginsArray([Bundle.main.path(forResource: "AABoost", ofType: "js") ?? ""]),
        AABoostChartComposer.scatterChartWith1MillionPoints().pluginsArray([Bundle.main.path(forResource: "AABoost", ofType: "js") ?? ""]),
        
        
    ] as [AAOptions]
    
//    var optionsItemsWithoutAnimation: [AAOptions] {
//        var aaOptionsArr = [AAOptions]()
//        for aaOptions in optionsItems {
//            aaOptions.plotOptions?.series?.animation = false
//            aaOptionsArr.append(aaOptions)
//        }
//        return aaOptionsArr
//    }
    
    var items: [Int] {
           return Array(0...optionsItems.count-1)
       }


    // 定义网格的列
    let columns: [GridItem] = [
        GridItem(.flexible()),  // 列宽自动调整
//        GridItem(.flexible()),
//        GridItem(.flexible())   // 3 列
    ]

    var body: some View {
        ScrollView { // 添加滚动视图支持
            LazyVGrid(columns: columns, spacing: 16) { // 设置列和间距
                ForEach(items, id: \.self) { item in
//                 //添加一个充满的红色背景视图
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.gray)
//                        .frame(height: 100) // 设置高度
                    AAChartViewRepresentable(chartOptions: Binding.constant(optionsItemsWithoutAnimation(chartOptions: optionsItems[item])))
                        .frame(height: 300)
                    
                   
                }
            }
            .padding() // 添加内边距
        }
    }
    
    func optionsItemsWithoutAnimation(chartOptions: AAOptions) -> AAOptions {
//        chartOptions.chart?.animation = false
        if chartOptions.chart != nil {
            chartOptions.chart?.animation = false
        } else {
            chartOptions.chart = AAChart()
            chartOptions.chart?.animation = false
        }  //🤔这里禁用动画不行, 有点奇怪, 后续再看看吧
        
        let chartOptions = configurePlotOptionsSeriesAnimation(chartOptions)
        return chartOptions
    }
    
    private func configurePlotOptionsSeriesAnimation(_ aaOptions: AAOptions) -> AAOptions {
        if aaOptions.plotOptions == nil {
            aaOptions.plotOptions = AAPlotOptions().series(AASeries().point(AAPoint().events(AAPointEvents())))
        } else if aaOptions.plotOptions?.series == nil {
            aaOptions.plotOptions?.series = AASeries().point(AAPoint().events(AAPointEvents()))
        } 
        
        aaOptions.plotOptions?.series?.animation = false
        return aaOptions
    }
}

//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}



//#Preview {
//    SwiftUIChartView()
//}

//#Preview {
//    GridView()
//}


class AARandomValueDataComposer {
    public static func configureChartOptions(chartType: AAChartType) -> AAOptions {
       let aaChartModel = AAChartModel()
            .chartType(chartType)//图形类型
            .title(chartType.rawValue)//图形标题
            .animationType(.easeOutQuart)//图形渲染动画类型为"bounce"
            .dataLabelsEnabled(false)//是否显示数字
            .markerRadius(4)//折线连接点半径长度,为0时相当于没有折线连接点
            .markerSymbolStyle(.innerBlank)
            .legendEnabled(false)
            .tooltipEnabled(true)
            .series([
                AASeriesElement()
                    .color("#fe117c")
                    .data(configureSeriesDataArray())
                ,
            ])
        
        return aaChartModel.aa_toAAOptions()
    }
    
    private static func configureSeriesDataArray() -> [Any] {
        let randomNumArrA = NSMutableArray()
        var y1 = 0.0
        let Q = arc4random() % 38
        for  x in 0 ..< 100 {
            y1 = sin(Double(Q) * (Double(x) * Double.pi / 180)) + Double(x) * 2.0 * 0.01 - 1
            randomNumArrA.add(
                AADataElement()
                    .color(AAColor.red)
                    .y(Float(y1)))
        }
        return randomNumArrA as! [Any]
    }
}
