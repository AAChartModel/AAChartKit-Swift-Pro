//
//  ProChartTableGalleryVC.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import UIKit

class ProChartTableGalleryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let cellIdentifier = "ChartExampleCell"
    private var tableView: UITableView!
    private let chartExamples = ChartSampleProvider.allProTypeSamples()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "AAChartView 示例"
        view.backgroundColor = .white

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChartExampleCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func optionsWithoutAnimation(_ chartOptions: AAOptions) -> AAOptions {
        if chartOptions.chart != nil {
            chartOptions.chart?.animation = false
        } else {
            chartOptions.chart = AAChart()
            chartOptions.chart?.animation = false
        }

        if chartOptions.plotOptions == nil {
            chartOptions.plotOptions = AAPlotOptions().series(AASeries())
        } else if chartOptions.plotOptions?.series == nil {
            chartOptions.plotOptions?.series = AASeries()
        }

        chartOptions.plotOptions?.series?.animation = false
        return chartOptions
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        360
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chartExamples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChartExampleCell else {
            return UITableViewCell()
        }

        let chartOptions = optionsWithoutAnimation(chartExamples[indexPath.row])
        cell.setChartOptions(chartOptions) { _ in }
        return cell
    }
}
