//
//  ChartListTableViewVC.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/18.
//

import UIKit

class ChartListTableViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    
    // 图表示例数据
    private let chartExamples = ChartSampleProvider.allProTypeSamples()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        title = "AAChartView 示例"
        view.backgroundColor = .white
        
        // 初始化并配置tableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        // 注册自定义单元格，假设您已创建 ChartExampleCell.swift
        tableView.register(ChartExampleCell.self, forCellReuseIdentifier: "ChartExampleCell")
        tableView.tableFooterView = UIView() // 去除空行的分割线
        
        view.addSubview(tableView)
        
        // 设置tableView约束（如果使用自动布局）
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func optionsItemsWithoutAnimation(chartOptions: AAOptions) -> AAOptions {
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
    
    // MARK: - UITableViewDataSource
    //设置高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 // 设置单元格高度
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartExamples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 使用自定义单元格标识符出列
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartExampleCell", for: indexPath) as? ChartExampleCell else {
            // 如果转换失败，返回一个默认的 UITableViewCell，虽然理论上不应该发生
            return UITableViewCell()
        }
        
        // 配置自定义单元格
        let chartOptions = chartExamples[indexPath.row]
        // 禁用动画
        let chartOptionsWithoutAnimation = optionsItemsWithoutAnimation(chartOptions: chartOptions)
        cell.configureChart(with: chartOptionsWithoutAnimation)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
}


