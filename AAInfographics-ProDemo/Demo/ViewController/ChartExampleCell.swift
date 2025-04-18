import UIKit

class ChartExampleCell: UITableViewCell {
    // 使用 lazy var 进行懒加载
    lazy var aaChartView: AAChartView = {
        let chartView = AAChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()

    //设置UI
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 将 setupUI 设为 private
    private func setupUI() {
        // 添加 AAChartView 到 cell 的 contentView
        contentView.addSubview(aaChartView)

        // 设置约束
        NSLayoutConstraint.activate([
            aaChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aaChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aaChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            aaChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
   
    //配置图表, 接收 AAOptions
    func configureChart(with options: AAOptions) {
        aaChartView.aa_drawChartWithChartOptions(options)
    }

    // 重写 prepareForReuse 方法以在单元格重用时清理
    override func prepareForReuse() {
        super.prepareForReuse()
        // 一个更安全的做法可能是加载一个空的 AAOptions 或默认状态
        // aaChartView.aa_drawChartWithChartOptions(AAOptions()) // 示例：绘制空图表
    }
}
