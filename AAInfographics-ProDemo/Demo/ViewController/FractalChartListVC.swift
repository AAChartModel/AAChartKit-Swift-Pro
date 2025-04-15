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
    private var chartOptions: [AAOptions] = [] // Empty array initially
    private var isLoading = true // Track loading state

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "基础分形图示例"
        
        setupCollectionView()
        loadChartOptionsAsync() // Start loading chart options asynchronously
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

    
    // 异步加载图表选项
    private func loadChartOptionsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Generate options in background thread
            let options = [
                AABoostFractalChartComposer.fractalMandelbrot(),
                AABoostFractalChartComposer.fractalSierpinskiTreeData(),
                AABoostFractalChartComposer.fractalSierpinskiTriangleData(),
                AABoostFractalChartComposer.fractalSierpinskiCarpetData(),
                AABoostFractalChartComposer.fractalJuliaSetData(),
                AABoostFractalChartComposer.fractalBarnsleyFern(),
                AABoostFractalChartComposer.fractalKochSnowflake(),
                
            ]
            
            // Return to main thread to update UI
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.chartOptions = options
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }
    
    // 创建图表模型
    private func createChartModel(index: Int) -> AAOptions? {
        guard index < chartOptions.count else { return nil }
        return chartOptions[index]
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FractalChartListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChartCollectionViewCell
        
        if isLoading || indexPath.item >= chartOptions.count {
            cell.showLoadingIndicator(true)
        } else {
            cell.showLoadingIndicator(false)
            if let chartOptions = createChartModel(index: indexPath.item) {
                cell.configureChart(with: chartOptions)
            }
        }
        
        return cell
    }
}

// MARK: - 自定义Chart单元格
class ChartCollectionViewCell: UICollectionViewCell {
    private var aaChartView: AAChartView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChartView() {
        // Add chart view
        aaChartView = AAChartView()
        contentView.addSubview(aaChartView)
        
        // Add loading indicator
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = false
        contentView.addSubview(loadingIndicator)
        
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
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aaChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aaChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aaChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            aaChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Center loading indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // Show or hide loading indicator
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
        } else {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
    }
    
    // 配置图表显示
    func configureChart(with chartOptions: AAOptions) {
        aaChartView.aa_drawChartWithChartOptions(chartOptions)
    }
}
