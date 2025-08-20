import UIKit

struct StageControlsStateUIKit {
    var mode: String = "connect" // "connect" | "dilate"
    var arcsEnabled: Bool = true
    var arcsMode: String = "concave" // "concave" | "convex"
    var barRadius: Float = 12.0
    var margin: Float = 8.0
    var externalRadius: Float = 18.0
    var opacity: Float = 0.38
    var seamEpsilon: Float = 0.5
    var sleepSegments: Int = 25
    var fixedGradient: Bool = true
}

final class StageControlsViewUIKit: UIView {
    // MARK: - Public callbacks
    var onChange: ((StageControlsStateUIKit) -> Void)?
    var onRandomData: ((Int) -> Void)?

    // MARK: - UI Elements
    private let stackView = UIStackView()
    private let modeSegmented = UISegmentedControl(items: ["connect", "dilate"])
    private let arcsSwitch = UISwitch()
    private let arcsModeSegmented = UISegmentedControl(items: ["concave", "convex"])

    private let barRadiusSlider = UISlider()
    private let barRadiusLabel = UILabel()
    private let marginSlider = UISlider()
    private let marginLabel = UILabel()
    private let externalRadiusSlider = UISlider()
    private let externalRadiusLabel = UILabel()
    private let opacitySlider = UISlider()
    private let opacityLabel = UILabel()
    private let seamEpsilonSlider = UISlider()
    private let seamEpsilonLabel = UILabel()
    private let sleepSegmentsSlider = UISlider()
    private let sleepSegmentsLabel = UILabel()

    private let fixedGradientSwitch = UISwitch()

    private let presetsContainer = UIStackView()

    // MARK: - State
    private var state = StageControlsStateUIKit()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        apply(state: state, emitChange: false)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        apply(state: state, emitChange: false)
    }

    // MARK: - Public API
    func getState() -> StageControlsStateUIKit { state }

    func setState(_ newState: StageControlsStateUIKit, emitChange: Bool = true) {
        apply(state: newState, emitChange: emitChange)
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Rows
        stackView.addArrangedSubview(labeledRow(title: "Mode", control: modeSegmented))
        stackView.addArrangedSubview(labeledRow(title: "Arcs", control: arcsSwitch))
        stackView.addArrangedSubview(labeledRow(title: "ArcsMode", control: arcsModeSegmented))

        configureSlider(barRadiusSlider, min: 0, max: 20)
        configureSlider(marginSlider, min: 0, max: 20)
        configureSlider(externalRadiusSlider, min: 0, max: 30)
        configureSlider(opacitySlider, min: 0, max: 1)
        configureSlider(seamEpsilonSlider, min: 0, max: 2)
        configureSlider(sleepSegmentsSlider, min: 8, max: 100)

        stackView.addArrangedSubview(sliderRow(title: "BarRadius", slider: barRadiusSlider, label: barRadiusLabel))
        stackView.addArrangedSubview(sliderRow(title: "Margin", slider: marginSlider, label: marginLabel))
        stackView.addArrangedSubview(sliderRow(title: "ExternalRadius", slider: externalRadiusSlider, label: externalRadiusLabel))
        stackView.addArrangedSubview(sliderRow(title: "Opacity", slider: opacitySlider, label: opacityLabel))
        stackView.addArrangedSubview(sliderRow(title: "SeamEpsilon", slider: seamEpsilonSlider, label: seamEpsilonLabel))
        stackView.addArrangedSubview(sliderRow(title: "SleepSegments", slider: sleepSegmentsSlider, label: sleepSegmentsLabel))

        stackView.addArrangedSubview(labeledRow(title: "Fixed Blue Gradient", control: fixedGradientSwitch))

        // Presets
        presetsContainer.axis = .horizontal
        presetsContainer.distribution = .fillEqually
        presetsContainer.spacing = 8
        let titles = ["ECharts Fluid", "ECharts Parity", "Safe Dilate", "Ultra-crisp", "Random Data"]
        titles.forEach { t in
            let btn = UIButton(type: .system)
            btn.setTitle(t, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
            btn.backgroundColor = .systemBlue
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 6
            btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
            btn.addTarget(self, action: #selector(presetTapped(_:)), for: .touchUpInside)
            presetsContainer.addArrangedSubview(btn)
        }
        stackView.addArrangedSubview(presetsContainer)

        // Actions
        modeSegmented.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        arcsSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        arcsModeSegmented.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        fixedGradientSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        [barRadiusSlider, marginSlider, externalRadiusSlider, opacitySlider, seamEpsilonSlider, sleepSegmentsSlider].forEach {
            $0.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        }
    }

    private func labeledRow(title: String, control: UIView) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        container.addSubview(titleLabel)
        container.addSubview(control)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        control.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            control.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            control.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            control.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor)
        ])
        return container
    }

    private func sliderRow(title: String, slider: UISlider, label: UILabel) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)

        container.addSubview(titleLabel)
        container.addSubview(slider)
        container.addSubview(label)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            slider.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            slider.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 60)
        ])
        return container
    }

    private func configureSlider(_ slider: UISlider, min: Float, max: Float) {
        slider.minimumValue = min
        slider.maximumValue = max
    }

    // MARK: - Apply / Update
    private func apply(state newState: StageControlsStateUIKit, emitChange: Bool) {
        state = newState

        modeSegmented.selectedSegmentIndex = (state.mode == "connect") ? 0 : 1
        arcsSwitch.isOn = state.arcsEnabled
        arcsModeSegmented.selectedSegmentIndex = (state.arcsMode == "concave") ? 0 : 1

        barRadiusSlider.value = state.barRadius
        marginSlider.value = state.margin
        externalRadiusSlider.value = state.externalRadius
        opacitySlider.value = state.opacity
        seamEpsilonSlider.value = state.seamEpsilon
        sleepSegmentsSlider.value = Float(state.sleepSegments)
        fixedGradientSwitch.isOn = state.fixedGradient

        updateValueLabels()
        if emitChange { notifyChange() }
    }

    private func updateValueLabels() {
        barRadiusLabel.text = String(format: "%.2f", barRadiusSlider.value)
        marginLabel.text = String(format: "%.2f", marginSlider.value)
        externalRadiusLabel.text = String(format: "%.2f", externalRadiusSlider.value)
        opacityLabel.text = String(format: "%.2f", opacitySlider.value)
        seamEpsilonLabel.text = String(format: "%.2f", seamEpsilonSlider.value)
        sleepSegmentsLabel.text = String(Int(sleepSegmentsSlider.value.rounded()))
    }

    private func notifyChange() {
        var s = StageControlsStateUIKit()
        s.mode = (modeSegmented.selectedSegmentIndex == 0) ? "connect" : "dilate"
        s.arcsEnabled = arcsSwitch.isOn
        s.arcsMode = (arcsModeSegmented.selectedSegmentIndex == 0) ? "concave" : "convex"
        s.barRadius = barRadiusSlider.value
        s.margin = marginSlider.value
        s.externalRadius = externalRadiusSlider.value
        s.opacity = opacitySlider.value
        s.seamEpsilon = seamEpsilonSlider.value
        s.sleepSegments = Int(sleepSegmentsSlider.value.rounded())
        s.fixedGradient = fixedGradientSwitch.isOn
        state = s
        onChange?(s)
    }

    // MARK: - Actions
    @objc private func valueChanged() {
        notifyChange()
    }

    @objc private func sliderChanged(_ slider: UISlider) {
        if slider === sleepSegmentsSlider {
            sleepSegmentsLabel.text = String(Int(slider.value.rounded()))
        } else if slider === barRadiusSlider {
            barRadiusLabel.text = String(format: "%.2f", slider.value)
        } else if slider === marginSlider {
            marginLabel.text = String(format: "%.2f", slider.value)
        } else if slider === externalRadiusSlider {
            externalRadiusLabel.text = String(format: "%.2f", slider.value)
        } else if slider === opacitySlider {
            opacityLabel.text = String(format: "%.2f", slider.value)
        } else if slider === seamEpsilonSlider {
            seamEpsilonLabel.text = String(format: "%.2f", slider.value)
        }
        notifyChange()
    }

    @objc private func presetTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        var newState = getState()
        switch title {
        case "ECharts Fluid":
            newState.mode = "connect"
            newState.arcsEnabled = true
            newState.arcsMode = "concave"
            newState.margin = 8.0
            newState.externalRadius = 18.0
            newState.opacity = 0.38
            newState.seamEpsilon = 0.5
            newState.barRadius = 12.0
            newState.sleepSegments = 20
            newState.fixedGradient = true
        case "ECharts Parity":
            newState.mode = "connect"
            newState.arcsEnabled = false
            newState.margin = 10.0
            newState.externalRadius = 24.0
            newState.opacity = 0.45
            newState.seamEpsilon = 1.0
            newState.barRadius = 8.0
            newState.sleepSegments = 30
            newState.fixedGradient = true
        case "Safe Dilate":
            newState.mode = "dilate"
            newState.arcsEnabled = false
            newState.margin = 10.0
            newState.externalRadius = 16.0
            newState.opacity = 0.42
            newState.seamEpsilon = 0.6
            newState.barRadius = 6.0
            newState.sleepSegments = 15
            newState.fixedGradient = true
        case "Ultra-crisp":
            newState.mode = "connect"
            newState.arcsEnabled = false
            newState.margin = 5.0
            newState.externalRadius = 2.0
            newState.opacity = 0.38
            newState.seamEpsilon = 0.0
            newState.barRadius = 3.0
            newState.sleepSegments = 80
            newState.fixedGradient = true
        case "Random Data":
            onRandomData?(Int(sleepSegmentsSlider.value.rounded()))
            // 不修改其它参数，仅触发随机数据
            return
        default:
            break
        }
        apply(state: newState, emitChange: true)
    }
}
