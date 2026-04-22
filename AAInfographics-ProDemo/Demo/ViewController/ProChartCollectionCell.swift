//
//  ProChartCollectionCell.swift
//  AAInfographics-ProDemo
//
//  Created by Codex on 2026/4/2.
//

import UIKit

class ProChartCollectionCell: UICollectionViewCell {
    private let chartView = AAChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor

        chartView.isScrollEnabled = false
        contentView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    func setChartOptions(_ chartOptions: AAOptions) {
        chartView.aa_drawChartWithChartOptions(chartOptions)
    }
}
