//
//  ProChartCollectionGalleryVC.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import UIKit

class ProChartCollectionGalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let cellIdentifier = "ProChartCollectionCell"
    private var collectionView: UICollectionView!
    private let chartExamples = ChartSampleProvider.allProTypeSamples()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "AAChartView 示例 (CollectionView)"
        view.backgroundColor = .systemGroupedBackground

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProChartCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chartExamples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProChartCollectionCell else {
            return UICollectionViewCell()
        }

        cell.setChartOptions(optionsWithoutAnimation(chartExamples[indexPath.item]))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 24
        return CGSize(width: width, height: 320)
    }
}
