import UIKit

@available(iOS 10.0, *)
//https://github.com/apache/echarts-custom-series
class AACustomStageChartVC: AABaseChartVC {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var controlsContainerView: UIView!
    private var chartContainerView: UIView!
    
    // 控制参数
    private var currentMode: String = "connect"
    private var arcsEnabled: Bool = true
    private var arcsMode: String = "convex"
    private var barRadius: Float = 12.0
    private var margin: Float = 8.0
    private var externalRadius: Float = 18.0
    private var opacity: Float = 0.38
    private var seamEpsilon: Float = 0.5
    private var sleepSegments: Int = 25
    private var fixedGradient: Bool = true
    
    // UI 控件
    private var modeSegmentedControl: UISegmentedControl!
    private var arcsSwitch: UISwitch!
    private var arcsModeSegmentedControl: UISegmentedControl!
    private var barRadiusSlider: UISlider!
    private var barRadiusLabel: UILabel!
    private var marginSlider: UISlider!
    private var marginLabel: UILabel!
    private var externalRadiusSlider: UISlider!
    private var externalRadiusLabel: UILabel!
    private var opacitySlider: UISlider!
    private var opacityLabel: UILabel!
    private var seamEpsilonSlider: UISlider!
    private var seamEpsilonLabel: UILabel!
    private var sleepSegmentsSlider: UISlider!
    private var sleepSegmentsLabel: UILabel!
    private var fixedGradientSwitch: UISwitch!
    
    // 数据模型
    private let categories = ["Deep", "Core", "REM", "Awake"]
    private let stageColors = ["#35349D", "#3478F6", "gold", "red"]
    private var currentDataset: [[String]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Style Chart"
        self.view.backgroundColor = UIColor.systemBackground
        
        setupData()
        setupUI()
        setupConstraints()
        setupActions()
        updateChart()
    }
    
    // MARK: - Data Setup
    private func setupData() {
        // 默认的睡眠数据（对应 HTML 中的 ECHARTS_DATASET）
        currentDataset = [
            ["2024-09-07 06:12", "2024-09-07 06:12", "Awake"],
            ["2024-09-07 06:15", "2024-09-07 06:18", "Awake"],
            ["2024-09-07 08:59", "2024-09-07 09:00", "Awake"],
            ["2024-09-07 05:45", "2024-09-07 06:12", "REM"],
            ["2024-09-07 07:37", "2024-09-07 07:56", "REM"],
            ["2024-09-07 08:56", "2024-09-07 08:59", "REM"],
            ["2024-09-07 09:08", "2024-09-07 09:29", "REM"],
            ["2024-09-07 03:12", "2024-09-07 03:27", "Core"],
            ["2024-09-07 04:02", "2024-09-07 04:36", "Core"],
            ["2024-09-07 04:40", "2024-09-07 04:48", "Core"],
            ["2024-09-07 04:57", "2024-09-07 05:45", "Core"],
            ["2024-09-07 06:12", "2024-09-07 06:15", "Core"],
            ["2024-09-07 06:18", "2024-09-07 07:37", "Core"],
            ["2024-09-07 07:56", "2024-09-07 08:56", "Core"],
            ["2024-09-07 09:00", "2024-09-07 09:08", "Core"],
            ["2024-09-07 09:29", "2024-09-07 10:41", "Core"],
            ["2024-09-07 03:27", "2024-09-07 04:02", "Deep"],
            ["2024-09-07 04:36", "2024-09-07 04:40", "Deep"],
            ["2024-09-07 04:48", "2024-09-07 04:57", "Deep"]
        ]
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
        
        setupControlsUI()
    }
    
    private func setupControlsUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.addSubview(stackView)
        
        // Mode 选择
        let modeRow = createLabeledControl(
            title: "Mode",
            control: createModeSegmentedControl(),
            spacing: 8
        )
        stackView.addArrangedSubview(modeRow)
        
        // Arcs 开关
        let arcsRow = createLabeledControl(
            title: "Arcs",
            control: createArcsSwitch(),
            spacing: 8
        )
        stackView.addArrangedSubview(arcsRow)
        
        // ArcsMode 选择
        let arcsModeRow = createLabeledControl(
            title: "ArcsMode",
            control: createArcsModeSegmentedControl(),
            spacing: 8
        )
        stackView.addArrangedSubview(arcsModeRow)
        
        // 滑块控件 - 修复：不再传递未初始化的变量
        let sliderConfigs: [(String, Float, Float, Float)] = [
            ("BarRadius", 0, 20, barRadius),
            ("Margin", 0, 20, margin),
            ("ExternalRadius", 0, 30, externalRadius),
            ("Opacity", 0, 1, opacity),
            ("SeamEpsilon", 0, 2, seamEpsilon),
            ("SleepSegments", 8, 100, Float(sleepSegments))
        ]
        
        for (title, min, max, value) in sliderConfigs {
            let row = createSliderRow(title: title, min: min, max: max, value: value)
            stackView.addArrangedSubview(row)
        }
        
        // Fixed Gradient 开关
        let gradientRow = createLabeledControl(
            title: "Fixed Blue Gradient",
            control: createFixedGradientSwitch(),
            spacing: 8
        )
        stackView.addArrangedSubview(gradientRow)
        
        // 预设按钮
        let buttonsRow = createPresetButtons()
        stackView.addArrangedSubview(buttonsRow)
        
        // 设置 stackView 约束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Control Creation Helpers
    private func createModeSegmentedControl() -> UISegmentedControl {
        modeSegmentedControl = UISegmentedControl(items: ["dilate", "connect"])
        modeSegmentedControl.selectedSegmentIndex = 1
        return modeSegmentedControl
    }
    
    private func createArcsSwitch() -> UISwitch {
        arcsSwitch = UISwitch()
        arcsSwitch.isOn = arcsEnabled
        return arcsSwitch
    }
    
    private func createArcsModeSegmentedControl() -> UISegmentedControl {
        arcsModeSegmentedControl = UISegmentedControl(items: ["convex", "concave"])
        arcsModeSegmentedControl.selectedSegmentIndex = 0
        return arcsModeSegmentedControl
    }
    
    private func createFixedGradientSwitch() -> UISwitch {
        fixedGradientSwitch = UISwitch()
        fixedGradientSwitch.isOn = fixedGradient
        return fixedGradientSwitch
    }
    
    private func createSliderRow(title: String, min: Float, max: Float, value: Float) -> UIView {
        let newSlider = UISlider()
        newSlider.minimumValue = min
        newSlider.maximumValue = max
        newSlider.value = value
        
        let newLabel = UILabel()
        newLabel.text = String(format: "%.2f", value)
        newLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        newLabel.textAlignment = .right
        newLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        // 将 slider 和 label 赋值到对应的实例变量
        switch title {
        case "BarRadius":
            barRadiusSlider = newSlider
            barRadiusLabel = newLabel
        case "Margin":
            marginSlider = newSlider
            marginLabel = newLabel
        case "ExternalRadius":
            externalRadiusSlider = newSlider
            externalRadiusLabel = newLabel
        case "Opacity":
            opacitySlider = newSlider
            opacityLabel = newLabel
        case "SeamEpsilon":
            seamEpsilonSlider = newSlider
            seamEpsilonLabel = newLabel
        case "SleepSegments":
            sleepSegmentsSlider = newSlider
            sleepSegmentsLabel = newLabel
        default:
            break
        }
        
        return createLabeledControl(title: title, control: newSlider, valueLabel: newLabel, spacing: 8)
    }
    
    private func createLabeledControl(title: String, control: UIView, valueLabel: UILabel? = nil, spacing: CGFloat) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(control)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        control.translatesAutoresizingMaskIntoConstraints = false
        
        if let valueLabel = valueLabel {
            containerView.addSubview(valueLabel)
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                
                control.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: spacing),
                control.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                control.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -spacing),
                
                valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                valueLabel.widthAnchor.constraint(equalToConstant: 50),
                
                containerView.heightAnchor.constraint(equalToConstant: 44)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                
                control.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: spacing),
                control.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                control.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
                
                containerView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        return containerView
    }
    
    private func createPresetButtons() -> UIView {
        let containerView = UIView()
        
        let buttonTitles = ["ECharts Fluid", "ECharts Parity", "Safe Dilate", "Ultra-crisp", "Random Data"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            button.backgroundColor = UIColor.systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 6
            button.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return containerView
    }
    
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
    
    // MARK: - Actions
    private func setupActions() {
        modeSegmentedControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        arcsSwitch.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        arcsModeSegmentedControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        fixedGradientSwitch.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        
        barRadiusSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        marginSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        externalRadiusSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        opacitySlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        seamEpsilonSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sleepSegmentsSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func controlValueChanged() {
        updateParameters()
        updateChart()
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        updateSliderLabel(slider)
        updateParameters()
        updateChart()
    }
    
    @objc private func presetButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        switch title {
        case "ECharts Fluid":
            applyFluidPreset()
        case "ECharts Parity":
            applyParityPreset()
        case "Safe Dilate":
            applySafeDilatePreset()
        case "Ultra-crisp":
            applyUltraCrispPreset()
        case "Random Data":
            generateRandomData()
        default:
            break
        }
        
        updateAllControlValues()
        updateChart()
    }
    
    // MARK: - Parameter Updates
    private func updateParameters() {
        currentMode = modeSegmentedControl.selectedSegmentIndex == 0 ? "dilate" : "connect"
        arcsEnabled = arcsSwitch.isOn
        arcsMode = arcsModeSegmentedControl.selectedSegmentIndex == 0 ? "convex" : "concave"
        barRadius = barRadiusSlider.value
        margin = marginSlider.value
        externalRadius = externalRadiusSlider.value
        opacity = opacitySlider.value
        seamEpsilon = seamEpsilonSlider.value
        sleepSegments = Int(sleepSegmentsSlider.value)
        fixedGradient = fixedGradientSwitch.isOn
    }
    
    private func updateSliderLabel(_ slider: UISlider) {
        let value = slider.value
        let label: UILabel
        
        switch slider {
        case barRadiusSlider:
            label = barRadiusLabel
        case marginSlider:
            label = marginLabel
        case externalRadiusSlider:
            label = externalRadiusLabel
        case opacitySlider:
            label = opacityLabel
        case seamEpsilonSlider:
            label = seamEpsilonLabel
        case sleepSegmentsSlider:
            label = sleepSegmentsLabel
        default:
            return
        }
        
        if slider == sleepSegmentsSlider {
            label.text = String(Int(value))
        } else {
            label.text = String(format: "%.2f", value)
        }
    }
    
    private func updateAllControlValues() {
        modeSegmentedControl.selectedSegmentIndex = currentMode == "dilate" ? 0 : 1
        arcsSwitch.isOn = arcsEnabled
        arcsModeSegmentedControl.selectedSegmentIndex = arcsMode == "convex" ? 0 : 1
        barRadiusSlider.value = barRadius
        marginSlider.value = margin
        externalRadiusSlider.value = externalRadius
        opacitySlider.value = opacity
        seamEpsilonSlider.value = seamEpsilon
        sleepSegmentsSlider.value = Float(sleepSegments)
        fixedGradientSwitch.isOn = fixedGradient
        
        updateSliderLabel(barRadiusSlider)
        updateSliderLabel(marginSlider)
        updateSliderLabel(externalRadiusSlider)
        updateSliderLabel(opacitySlider)
        updateSliderLabel(seamEpsilonSlider)
        updateSliderLabel(sleepSegmentsSlider)
    }
    
    // MARK: - Preset Configurations
    private func applyFluidPreset() {
        currentMode = "connect"
        arcsEnabled = true
        arcsMode = "concave"
        margin = 8.0
        externalRadius = 18.0
        opacity = 0.38
        seamEpsilon = 0.5
        barRadius = 12.0
        sleepSegments = 20
        fixedGradient = true
    }
    
    private func applyParityPreset() {
        currentMode = "connect"
        arcsEnabled = false
        margin = 10.0
        externalRadius = 24.0
        opacity = 0.45
        seamEpsilon = 1.0
        barRadius = 8.0
        sleepSegments = 30
        fixedGradient = true
    }
    
    private func applySafeDilatePreset() {
        currentMode = "dilate"
        arcsEnabled = false
        margin = 10.0
        externalRadius = 16.0
        opacity = 0.42
        seamEpsilon = 0.6
        barRadius = 6.0
        sleepSegments = 15
        fixedGradient = true
    }
    
    private func applyUltraCrispPreset() {
        currentMode = "connect"
        arcsEnabled = false
        margin = 5.0
        externalRadius = 2.0
        opacity = 0.38
        seamEpsilon = 0.0
        barRadius = 3.0
        sleepSegments = 80
        fixedGradient = true
    }
    
    private func generateRandomData() {
        currentDataset = AAOptionsData.randomSleepData(count: sleepSegments)
    }
    
    // MARK: - Chart Configuration
    override func chartConfigurationWithSelectedIndex(_ selectedIndex: Int) -> Any? {
        return createChartOptions()
    }
    
    private func createChartOptions() -> AAOptions {
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
        return AACustomStageChartComposer.createStageChartOptions(
            dataset: currentDataset,
            envelope: envelope,
            barRadius: barRadius
        )
    }
    
    private func updateChart() {
        // 移除旧的图表视图
        aaChartView?.removeFromSuperview()
        
        // 创建新的图表视图
        aaChartView = AAChartView()
        aaChartView!.isScrollEnabled = false
        aaChartView!.delegate = self
        
        /**
         NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"AADrilldown" ofType:@"js"];
         self.aaChartView.pluginsArray = @[jsPath];
         */
        let jsPath: String = Bundle.main.path(forResource: "AAStageSeries", ofType: "js") ?? ""
        self.aaChartView?.userPluginPaths = [jsPath]
        
        //输出查看 AAOption 的 computedProperties 内容
//        AAOptions *aaOptions = [self chartConfigurationWithSelectedIndex:self.selectedIndex];
        let aaOptions: AAOptions = self.chartConfigurationWithSelectedIndex(self.selectedIndex) as! AAOptions
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
        
        // 绘制图表
        let chartOptions = createChartOptions()
        aaChartView!.aa_drawChartWithChartOptions(chartOptions)
    }
    
    // MARK: - Utility Functions
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: dateString)
    }
    
   
}
