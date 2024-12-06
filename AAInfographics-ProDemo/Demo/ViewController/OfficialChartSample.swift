//
//  OfficialChartSample.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2024/12/6.
//

import SwiftUI

// 封装 AAChartView
struct AAChartViewRepresentable: UIViewRepresentable {
    @Binding var chartModel: AAChartModel
    
    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.scrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: AAChartView, context: Context) {
        uiView.aa_drawChartWithChartModel(chartModel)
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
            AAChartViewRepresentable(chartModel: $chartModel)
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartModel: $chartModel)
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartModel: $chartModel)
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartModel: $chartModel)
                .frame(height: 300) // 设置图表高度
            AAChartViewRepresentable(chartModel: $chartModel)
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


#Preview {
    SwiftUIChartView()
}
