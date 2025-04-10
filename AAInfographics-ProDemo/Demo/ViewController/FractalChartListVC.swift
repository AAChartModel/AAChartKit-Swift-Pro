//
//  AAFractalChartListViewController.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/10.
//

import UIKit

class FractalChartListVC: UIViewController {
    
    private let cellIdentifier = "ChartCell"
    private var collectionView: UICollectionView!
    private let chartOptions = [
        AABoostFractalChartComposer.fractalMandelbrot(),
        AABoostFractalChartComposer.fractalSierpinskiTreeData(),
        AABoostFractalChartComposer.fractalSierpinskiTriangleData(),
        AABoostFractalChartComposer.fractalSierpinskiCarpetData(),
        AABoostFractalChartComposer.fractalJuliaSetData(),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "基础分形图示例"
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        // 设置布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let screenWidth = self.view.bounds.width
        let itemWidth = (screenWidth - 40) / 2 // 两列布局，左右各10点边距，中间20点间距
        layout.itemSize = CGSize(width: itemWidth, height: 400)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        // 创建CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // 添加到视图
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // 创建四种不同的柱状图
    private func createChartModel(index: Int) -> AAOptions {
        let aaOptions = chartOptions[index]
        return aaOptions
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FractalChartListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChartCollectionViewCell
        
        let chartOptions = createChartModel(index: indexPath.item)
        cell.configureChart(with: chartOptions)
        
        return cell
    }
}

// MARK: - 自定义Chart单元格
class ChartCollectionViewCell: UICollectionViewCell {
    private var aaChartView: AAChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChartView() {
        aaChartView = AAChartView()
        contentView.addSubview(aaChartView)
        
        // 设置圆角和阴影效果
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        
        aaChartView.layer.cornerRadius = 12
        aaChartView.layer.masksToBounds = true
        
        // 设置布局
        aaChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aaChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aaChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aaChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            aaChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // 配置图表显示
    func configureChart(with chartOptions: AAOptions) {
        aaChartView.aa_drawChartWithChartOptions(chartOptions)
    }
}
