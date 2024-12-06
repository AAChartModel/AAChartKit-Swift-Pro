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
    
    ] as [AAOptions]
    
    var items: [Int] {
           return Array(0...optionsItems.count-1)
       }


    // 定义网格的列
    let columns: [GridItem] = [
        GridItem(.flexible()),  // 列宽自动调整
        GridItem(.flexible()),
        GridItem(.flexible())   // 3 列
    ]

    var body: some View {
        ScrollView { // 添加滚动视图支持
            LazyVGrid(columns: columns, spacing: 16) { // 设置列和间距
                ForEach(items, id: \.self) { item in
//                 //添加一个充满的红色背景视图
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.gray)
//                        .frame(height: 100) // 设置高度
                    AAChartViewRepresentable(chartOptions: Binding.constant(optionsItems[item]))
                        .frame(height: 300)
                    
                   
                }
            }
            .padding() // 添加内边距
        }
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
