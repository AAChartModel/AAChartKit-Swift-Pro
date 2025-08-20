import UIKit

@available(iOS 10.0, *)
//https://github.com/apache/echarts-custom-series
class AACustomStageChartVC: UIViewController {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var controlsContainerView: UIView!
    private var chartContainerView: UIView!
    var aaChartView: AAChartView!
    private var controlsView: StageControlsViewUIKit!
    private var shouldResetOnAppear: Bool = true

    // 控制参数
    private var currentMode: String = "connect"
    private var arcsEnabled: Bool = true
    private var arcsMode: String = "concave"
    private var barRadius: Float = 12.0
    private var margin: Float = 8.0
    private var externalRadius: Float = 18.0
    private var opacity: Float = 0.38
    private var seamEpsilon: Float = 0.5
    private var sleepSegments: Int = 25
    private var fixedGradient: Bool = true
    
    // 已迁移到 SwiftUI 控制面板
    
    // 数据模型
    private let categories = ["Deep", "Core", "REM", "Awake"]
    private let stageColors = ["#35349D", "#3478F6", "gold", "red"]
    private var currentDataset: [[String]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Style Chart"
        self.view.backgroundColor = UIColor.systemBackground
        
        
        
    setupUI()
    setupConstraints()
        
        setupChartView()
        //
        //        // 创建新的图表视图
        //        aaChartView = AAChartView()
        //        aaChartView!.isScrollEnabled = false
        //        aaChartView!.delegate = self
                
                /**
                 NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"AADrilldown" ofType:@"js"];
                 self.aaChartView.pluginsArray = @[jsPath];
                 */
                let jsPath: String = Bundle.main.path(forResource: "AACustom-Stage", ofType: "js") ?? ""
                self.aaChartView?.userPluginPaths = [jsPath]
                
                //输出查看 AAOption 的 computedProperties 内容
        //        AAOptions *aaOptions = [self chartConfigurationWithSelectedIndex:self.selectedIndex];
        let aaOptions: AAOptions = AACustomStageChartComposer.defaultOptions 
                print("AAOptions 新增的计算属性 computedProperties: \(String(describing: aaOptions.computedProperties()))")

        chartContainerView.addSubview(aaChartView!)
        
        
        
        
        // 设置约束
        aaChartView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aaChartView!.topAnchor.constraint(equalTo: chartContainerView.topAnchor),
            aaChartView!.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
            aaChartView!.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor),
            aaChartView!.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor)
        ])

        
        drawChart()
    }
    
    private func setupChartView() {
        aaChartView = AAChartView()
        aaChartView!.isScrollEnabled = false
//        aaChartView!.delegate = self as AAChartViewDelegate
    }
    
    private func drawChart() {
        // 绘制图表
        let chartOptions = AACustomStageChartComposer.defaultOptions
        aaChartView!.aa_drawChartWithChartOptions(chartOptions)
    }

    
    // MARK: - UI Setup
    private func setupUI() {
        // 主滚动视图
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.systemBackground
        view.addSubview(scrollView)
        
        // 控制面板容器
        controlsContainerView = UIView()
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.backgroundColor = UIColor.systemBackground
        controlsContainerView.layer.cornerRadius = 10
        controlsContainerView.layer.borderWidth = 1
        controlsContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        scrollView.addSubview(controlsContainerView)
        
        // 图表容器
        chartContainerView = UIView()
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.backgroundColor = UIColor.white
        scrollView.addSubview(chartContainerView)
        
        setupUIKitControls()
    }
    
    private func setupUIKitControls() {
        controlsView = StageControlsViewUIKit()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.addSubview(controlsView)
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 12),
            controlsView.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 12),
            controlsView.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -12),
            controlsView.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -12)
        ])

        // 初始同步当前参数
        var initState = StageControlsStateUIKit()
        initState.mode = currentMode
        initState.arcsEnabled = arcsEnabled
        initState.arcsMode = arcsMode
        initState.barRadius = barRadius
        initState.margin = margin
        initState.externalRadius = externalRadius
        initState.opacity = opacity
        initState.seamEpsilon = seamEpsilon
        initState.sleepSegments = sleepSegments
        initState.fixedGradient = fixedGradient
        controlsView.setState(initState, emitChange: false)

        // 回调绑定
        controlsView.onChange = { [weak self] newState in
            guard let self = self else { return }
            self.currentMode = newState.mode
            self.arcsEnabled = newState.arcsEnabled
            self.arcsMode = newState.arcsMode
            self.barRadius = newState.barRadius
            self.margin = newState.margin
            self.externalRadius = newState.externalRadius
            self.opacity = newState.opacity
            self.seamEpsilon = newState.seamEpsilon
            self.sleepSegments = newState.sleepSegments
            self.fixedGradient = newState.fixedGradient
            self.updateChart()
        }
        controlsView.onRandomData = { [weak self] count in
            guard let self = self else { return }
            self.currentDataset = AAOptionsData.randomSleepData(count: count)
            self.updateChart()
        }
    }
    
    // MARK: - Control Creation Helpers moved to SwiftUI
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView 约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 控制面板约束
            controlsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            controlsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            controlsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            // 图表容器约束
            chartContainerView.topAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: 8),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chartContainerView.heightAnchor.constraint(equalToConstant: 400),
            chartContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Actions handled via UIKit callbacks
    
    // MARK: - Preset Configurations
    private func generateRandomData() {
        currentDataset = AAOptionsData.randomSleepData(count: sleepSegments)
    }

    
    private func updateChartOptions() -> AAOptions {
        // 创建包络层配置
        let envelope = AACustomStageChartComposer.createEnvelopeConfig(
            mode: currentMode,
            arcsEnabled: arcsEnabled,
            arcsMode: arcsMode,
            margin: margin,
            externalRadius: externalRadius,
            opacity: opacity,
            seamEpsilon: seamEpsilon,
            fixedGradient: fixedGradient
        )

        // 使用 Composer 创建完整的图表配置
        return AACustomStageChartComposer.updateStageChartOptions(
            dataset: currentDataset,
            envelope: envelope,
            barRadius: barRadius
        )
    }
    
    private func updateChart() {
        // 绘制图表
        let chartOptions = updateChartOptions()
        aaChartView!.aa_drawChartWithChartOptions(chartOptions)
    }
    
    // MARK: - Utility Functions
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: dateString)
    }
    
    
    // 调试：观察控制器是否被释放，避免无意复用导致状态保留
    deinit {
        print("AACustomStageChartVC deinit")
    }

   
}
