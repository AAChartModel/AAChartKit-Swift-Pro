import UIKit
import SwiftUI

@available(iOS 10.0, *)
//https://github.com/apache/echarts-custom-series
class AACustomStageChartVC: UIViewController {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var controlsContainerView: UIView!
    private var chartContainerView: UIView!
    var aaChartView: AAChartView!
    private var hostingController: UIViewController?
    @available(iOS 13.0, *)
    private var stageState: StageControlsState = StageControlsState()

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
        
        setupSwiftUIControls()
    }

    private func setupSwiftUIControls() {
        if #available(iOS 13.0, *) {
            let view = StageControlsView(
                state: stageState,
                onChange: { [weak self] in self?.updateChart() },
                onRandomData: { [weak self] in self?.generateRandomData() }
            )
            let host = UIHostingController(rootView: view)
            hostingController = host
            addChild(host)
            controlsContainerView.addSubview(host.view)
            host.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 12),
                host.view.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 12),
                host.view.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -12),
                host.view.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -12)
            ])
            host.didMove(toParent: self)
        } else {
            // Fallback for iOS < 13
            let label = UILabel()
            label.text = "需要 iOS 13+ 才能显示控制面板"
            label.textAlignment = .center
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            controlsContainerView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 12),
                label.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -12),
                label.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -12),
                label.heightAnchor.constraint(equalToConstant: 44)
            ])
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
    
    // MARK: - Actions handled via SwiftUI callbacks
    
    // UIKit 控件已移除，参数变化通过 StageControlsState 驱动
    
    // MARK: - Preset Configurations
    private func generateRandomData() {
        if #available(iOS 13.0, *) {
            currentDataset = AAOptionsData.randomSleepData(count: stageState.sleepSegments)
        } else {
            currentDataset = AAOptionsData.randomSleepData(count: sleepSegments)
        }
    }

    
    private func updateChartOptions() -> AAOptions {
        // 创建包络层配置
        let envelope = {
            if #available(iOS 13.0, *) {
                return AACustomStageChartComposer.createEnvelopeConfig(
                    mode: stageState.mode.rawValue,
                    arcsEnabled: stageState.arcsEnabled,
                    arcsMode: stageState.arcsMode.rawValue,
                    margin: stageState.margin,
                    externalRadius: stageState.externalRadius,
                    opacity: stageState.opacity,
                    seamEpsilon: stageState.seamEpsilon,
                    fixedGradient: stageState.fixedGradient
                )
            } else {
                return AACustomStageChartComposer.createEnvelopeConfig(
                    mode: currentMode,
                    arcsEnabled: arcsEnabled,
                    arcsMode: arcsMode,
                    margin: margin,
                    externalRadius: externalRadius,
                    opacity: opacity,
                    seamEpsilon: seamEpsilon,
                    fixedGradient: fixedGradient
                )
            }
        }()
        
        let barRadiusValue: Float
        if #available(iOS 13.0, *) {
            barRadiusValue = stageState.barRadius
        } else {
            barRadiusValue = barRadius
        }

        // 使用 Composer 创建完整的图表配置
        return AACustomStageChartComposer.updateStageChartOptions(
            dataset: currentDataset,
            envelope: envelope,
            barRadius: barRadiusValue
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
    
   
}
