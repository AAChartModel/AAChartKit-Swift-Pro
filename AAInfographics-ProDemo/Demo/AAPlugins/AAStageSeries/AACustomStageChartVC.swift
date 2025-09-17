import UIKit

@available(iOS 10.0, *)
//https://github.com/apache/echarts-custom-series
class AACustomStageChartVC: UIViewController {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var controlsContainerView: UIView!
    private var chartContainerView: UIView!
    var aaChartView: AAChartView!
    var aaOptions: AAOptions!
    private var controlsView: AAStageControlsView!
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
    
    private var currentDataset: [[String]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Style Chart"
        self.view.backgroundColor = UIColor.systemBackground
        
        
        setupUI()
        setupConstraints()
        setupChartView()
    }
    
    private func setupChartView() {
        // 创建新的图表视图
        aaChartView = AAChartView()
        aaChartView.isScrollEnabled = false
        aaChartView.delegate = self as AAChartViewDelegate
        
        /**
         NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"AADrilldown" ofType:@"js"];
         self.aaChartView.pluginsArray = @[jsPath];
         */
        
        // 定义JS文件名常量，避免重复拼写
        let xrangeFileName = "AAXrange"
        let customStageFileName = "AACustom-Stage"
        let jsExtension = "js"
        
        // 使用正确的 Bundle 路径和目录结构来加载 AAXrange.js 文件
        let jsPathXrange: String = BundlePathLoader().path(
            forResource: xrangeFileName,
            ofType: jsExtension,
            inDirectory: "AAJSFiles.bundle/AAModules"
        ) ?? ""
        
        // 使用 Bundle.main 加载位于项目 Demo 目录中的 AACustom-Stage.js 文件
        guard let jsPathCustom_Stage = Bundle.main.path(forResource: customStageFileName, ofType: jsExtension) else {
            print("Error: Could not find \(customStageFileName).\(jsExtension)")
            return
        }

        // 配置需要加载的插件JS文件路径数组
        aaChartView.userPluginPaths = [
            jsPathXrange,
            jsPathCustom_Stage,
        ]
        
        // 配置它们的依赖关系 - 使用文件名常量构建完整文件名
        //此处的依赖关系配置非常重要, 关系到 JS 插件的加载顺序
        // 例如: AAXrange.js 必须在 AACustom-Stage.js 之前加载
        aaChartView.dependencies = [
            AADependency("\(customStageFileName).\(jsExtension)", on: "\(xrangeFileName).\(jsExtension)"),
            // 如果还有其他依赖, 继续在这里添加
            // AADependency("pluginC.js", on: "pluginA.js")
        ]


        
        //输出查看 AAOption 的 computedProperties 内容
        //        AAOptions *aaOptions = [self chartConfigurationWithSelectedIndex:self.selectedIndex];
        self.aaOptions = AACustomStageChartComposer.defaultOptions()
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
    
    private func drawChart() {
        // 绘制图表
        let chartOptions = self.aaOptions
        aaChartView!.aa_drawChartWithChartOptions(chartOptions!)
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
        controlsView = AAStageControlsView()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.addSubview(controlsView)
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 12),
            controlsView.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 12),
            controlsView.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -12),
            controlsView.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -12)
        ])

        // 初始同步当前参数
        var initState = AAStageControlsState()
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
            chartOptions: self.aaOptions,
            dataset: currentDataset,
            envelope: envelope,
            barRadius: barRadius
        )
    }
    
    private func updateChart() {
        // 绘制图表
        let chartOptions = updateChartOptions()
        aaChartView!.aa_updateChart(options: chartOptions, redraw: true)
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



extension AACustomStageChartVC: AAChartViewDelegate {
    open func aaChartViewDidFinishLoad(_ aaChartView: AAChartView) {
       print("🚀🚀🚀, AAChartView Did Finished Load!!!")
    }
    
    open func aaChartView(_ aaChartView: AAChartView, clickEventMessage: AAClickEventMessageModel) {
           print(
               """

               clicked point series element name: \(clickEventMessage.name ?? "")
               🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! Click Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
               ==========================================================================================
               ------------------------------------------------------------------------------------------
               user finger moved over!!!,get the move over event message: {
               category = \(String(describing: clickEventMessage.category))
               index = \(String(describing: clickEventMessage.index))
               name = \(String(describing: clickEventMessage.name))
               offset = \(String(describing: clickEventMessage.offset))
               x = \(String(describing: clickEventMessage.x))
               y = \(String(describing: clickEventMessage.y))
               }
               +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               
               
               """
           )
       }

    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        print(
            """
            
            selected point series element name: \(moveOverEventMessage.name ?? "")
            👌👌👌WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING👌👌👌
            || ==========================================================================================
            || ------------------------------------------------------------------------------------------
            || user finger moved over!!!,get the move over event message: {
            || category = \(String(describing: moveOverEventMessage.category))
            || index = \(String(describing: moveOverEventMessage.index))
            || name = \(String(describing: moveOverEventMessage.name))
            || offset = \(String(describing: moveOverEventMessage.offset))
            || x = \(String(describing: moveOverEventMessage.x))
            || y = \(String(describing: moveOverEventMessage.y))
            || }
            || ------------------------------------------------------------------------------------------
            || ==========================================================================================
            
            
            """
        )
    }
}
