import SwiftUI
import UIKit

struct AAStageControlsState {
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

final class AAStageControlsView: UIView {
    // MARK: - Public callbacks
    var onChange: ((AAStageControlsState) -> Void)?
    var onRandomData: ((Int) -> Void)?

    // MARK: - Private properties
    private let viewModel: StageControlsViewModel
    private let hostingController: UIHostingController<StageControlsContainerView>

    // MARK: - Init
    override init(frame: CGRect) {
        let initialViewModel = StageControlsViewModel(state: AAStageControlsState())
        self.viewModel = initialViewModel
        self.hostingController = UIHostingController(rootView: StageControlsContainerView(viewModel: initialViewModel))
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        let initialViewModel = StageControlsViewModel(state: AAStageControlsState())
        self.viewModel = initialViewModel
        self.hostingController = UIHostingController(rootView: StageControlsContainerView(viewModel: initialViewModel))
        super.init(coder: coder)
        configure()
    }

    // MARK: - Public API
    func getState() -> AAStageControlsState { viewModel.state }

    func setState(_ newState: AAStageControlsState, emitChange: Bool = true) {
        viewModel.apply(state: newState, emitChange: emitChange)
    }

    // MARK: - Private helpers
    private func configure() {
        backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.onChange?(state)
        }

        viewModel.onRandomData = { [weak self] count in
            self?.onRandomData?(count)
        }
    }
}

// MARK: - ViewModel

@MainActor
private final class StageControlsViewModel: ObservableObject {
    @Published private(set) var state: AAStageControlsState

    var onStateChange: ((AAStageControlsState) -> Void)?
    var onRandomData: ((Int) -> Void)?

    private var shouldEmitChanges: Bool = true

    init(state: AAStageControlsState) {
        self.state = state
    }

    func apply(state newState: AAStageControlsState, emitChange: Bool) {
        shouldEmitChanges = emitChange
        state = newState
        defer { shouldEmitChanges = true }
        if emitChange {
            notifyChange()
        }
    }

    func setMode(_ mode: String) {
        mutate { $0.mode = mode }
    }

    func setArcsEnabled(_ enabled: Bool) {
        mutate { $0.arcsEnabled = enabled }
    }

    func setArcsMode(_ mode: String) {
        mutate { $0.arcsMode = mode }
    }

    func setBarRadius(_ value: Float) {
        mutate { $0.barRadius = value }
    }

    func setMargin(_ value: Float) {
        mutate { $0.margin = value }
    }

    func setExternalRadius(_ value: Float) {
        mutate { $0.externalRadius = value }
    }

    func setOpacity(_ value: Float) {
        mutate { $0.opacity = value }
    }

    func setSeamEpsilon(_ value: Float) {
        mutate { $0.seamEpsilon = value }
    }

    func setSleepSegments(_ value: Int) {
        mutate { $0.sleepSegments = value }
    }

    func setFixedGradient(_ enabled: Bool) {
        mutate { $0.fixedGradient = enabled }
    }

    func triggerRandomData() {
        onRandomData?(state.sleepSegments)
    }

    func applyPreset(_ preset: StagePreset) {
        var updatedState = state
        preset.configure(&updatedState)
        apply(state: updatedState, emitChange: true)
    }

    private func mutate(_ update: (inout AAStageControlsState) -> Void) {
        update(&state)
        notifyChange()
    }

    private func notifyChange() {
        guard shouldEmitChanges else { return }
        onStateChange?(state)
    }
}

// MARK: - Presets

private enum StagePreset: String, CaseIterable, Identifiable {
    case echartsFluid = "ECharts Fluid"
    case echartsParity = "ECharts Parity"
    case safeDilate = "Safe Dilate"
    case ultraCrisp = "Ultra-crisp"
    case randomData = "Random Data"

    var id: String { rawValue }

    var isRandom: Bool { self == .randomData }

    func configure(_ state: inout AAStageControlsState) {
        switch self {
        case .echartsFluid:
            state.mode = "connect"
            state.arcsEnabled = true
            state.arcsMode = "concave"
            state.margin = 8.0
            state.externalRadius = 18.0
            state.opacity = 0.38
            state.seamEpsilon = 0.5
            state.barRadius = 12.0
            state.sleepSegments = 20
            state.fixedGradient = true
        case .echartsParity:
            state.mode = "connect"
            state.arcsEnabled = false
            state.margin = 10.0
            state.externalRadius = 24.0
            state.opacity = 0.45
            state.seamEpsilon = 1.0
            state.barRadius = 8.0
            state.sleepSegments = 30
            state.fixedGradient = true
        case .safeDilate:
            state.mode = "dilate"
            state.arcsEnabled = false
            state.margin = 10.0
            state.externalRadius = 16.0
            state.opacity = 0.42
            state.seamEpsilon = 0.6
            state.barRadius = 6.0
            state.sleepSegments = 15
            state.fixedGradient = true
        case .ultraCrisp:
            state.mode = "connect"
            state.arcsEnabled = false
            state.margin = 5.0
            state.externalRadius = 2.0
            state.opacity = 0.38
            state.seamEpsilon = 0.0
            state.barRadius = 3.0
            state.sleepSegments = 80
            state.fixedGradient = true
        case .randomData:
            break
        }
    }
}

// MARK: - SwiftUI View

private struct StageControlsContainerView: View {
    @ObservedObject var viewModel: StageControlsViewModel

    private let titleFont: Font = .system(size: 14, weight: .medium)
    private let valueFont: Font = .system(size: 14, weight: .regular, design: .monospaced)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            segmentedRow(
                title: "Mode",
                selection: Binding(
                    get: { viewModel.state.mode },
                    set: { viewModel.setMode($0) }
                ),
                options: ["connect", "dilate"]
            )

            toggleRow(
                title: "Arcs",
                isOn: Binding(
                    get: { viewModel.state.arcsEnabled },
                    set: { viewModel.setArcsEnabled($0) }
                )
            )

            segmentedRow(
                title: "ArcsMode",
                selection: Binding(
                    get: { viewModel.state.arcsMode },
                    set: { viewModel.setArcsMode($0) }
                ),
                options: ["concave", "convex"]
            )

            sliderRow(
                title: "BarRadius",
                binding: Binding(
                    get: { Double(viewModel.state.barRadius) },
                    set: { viewModel.setBarRadius(Float($0)) }
                ),
                range: 0...20,
                step: 0.01,
                displayText: String(format: "%.2f", viewModel.state.barRadius)
            )

            sliderRow(
                title: "Margin",
                binding: Binding(
                    get: { Double(viewModel.state.margin) },
                    set: { viewModel.setMargin(Float($0)) }
                ),
                range: 0...20,
                step: 0.01,
                displayText: String(format: "%.2f", viewModel.state.margin)
            )

            sliderRow(
                title: "ExternalRadius",
                binding: Binding(
                    get: { Double(viewModel.state.externalRadius) },
                    set: { viewModel.setExternalRadius(Float($0)) }
                ),
                range: 0...30,
                step: 0.01,
                displayText: String(format: "%.2f", viewModel.state.externalRadius)
            )

            sliderRow(
                title: "Opacity",
                binding: Binding(
                    get: { Double(viewModel.state.opacity) },
                    set: { viewModel.setOpacity(Float($0)) }
                ),
                range: 0...1,
                step: 0.01,
                displayText: String(format: "%.2f", viewModel.state.opacity)
            )

            sliderRow(
                title: "SeamEpsilon",
                binding: Binding(
                    get: { Double(viewModel.state.seamEpsilon) },
                    set: { viewModel.setSeamEpsilon(Float($0)) }
                ),
                range: 0...2,
                step: 0.01,
                displayText: String(format: "%.2f", viewModel.state.seamEpsilon)
            )

            sliderRow(
                title: "SleepSegments",
                binding: Binding(
                    get: { Double(viewModel.state.sleepSegments) },
                    set: { viewModel.setSleepSegments(Int($0.rounded())) }
                ),
                range: 8...100,
                step: 1,
                displayText: String(viewModel.state.sleepSegments)
            )

            toggleRow(
                title: "Fixed Blue Gradient",
                isOn: Binding(
                    get: { viewModel.state.fixedGradient },
                    set: { viewModel.setFixedGradient($0) }
                )
            )

            presetButtons
        }
        .padding(.vertical, 4)
    }

    private func segmentedRow(title: String, selection: Binding<String>, options: [String]) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(titleFont)
                .frame(width: 120, alignment: .leading)
            Picker("", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func toggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(titleFont)
                .frame(width: 120, alignment: .leading)
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
    }

    private func sliderRow(title: String, binding: Binding<Double>, range: ClosedRange<Double>, step: Double, displayText: String) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(titleFont)
                .frame(width: 120, alignment: .leading)
            Slider(value: binding, in: range, step: step)
            Text(displayText)
                .font(valueFont)
                .frame(width: 70, alignment: .trailing)
        }
    }

    private var presetButtons: some View {
        HStack(spacing: 8) {
            ForEach(StagePreset.allCases) { preset in
                Button {
                    if preset.isRandom {
                        viewModel.triggerRandomData()
                    } else {
                        viewModel.applyPreset(preset)
                    }
                } label: {
                    Text(preset.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(6)
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
