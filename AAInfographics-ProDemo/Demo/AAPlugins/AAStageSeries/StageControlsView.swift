import Foundation
import SwiftUI

@available(iOS 13.0, *)
final class StageControlsState: ObservableObject {
    enum Mode: String, CaseIterable, Identifiable {
        case connect
        case dilate
        var id: String { rawValue }
    }

    enum ArcsMode: String, CaseIterable, Identifiable {
        case concave
        case convex
        var id: String { rawValue }
    }

    // Published parameters
    @Published var mode: Mode = .connect
    @Published var arcsEnabled: Bool = true
    @Published var arcsMode: ArcsMode = .concave
    @Published var barRadius: Float = 12.0
    @Published var margin: Float = 8.0
    @Published var externalRadius: Float = 18.0
    @Published var opacity: Float = 0.38
    @Published var seamEpsilon: Float = 0.5
    @Published var sleepSegments: Int = 25
    @Published var fixedGradient: Bool = true

    // Presets
    func applyFluidPreset() {
        mode = .connect
        arcsEnabled = true
        arcsMode = .concave
        margin = 8.0
        externalRadius = 18.0
        opacity = 0.38
        seamEpsilon = 0.5
        barRadius = 12.0
        sleepSegments = 20
        fixedGradient = true
    }

    func applyParityPreset() {
        mode = .connect
        arcsEnabled = false
        margin = 10.0
        externalRadius = 24.0
        opacity = 0.45
        seamEpsilon = 1.0
        barRadius = 8.0
        sleepSegments = 30
        fixedGradient = true
    }

    func applySafeDilatePreset() {
        mode = .dilate
        arcsEnabled = false
        margin = 10.0
        externalRadius = 16.0
        opacity = 0.42
        seamEpsilon = 0.6
        barRadius = 6.0
        sleepSegments = 15
        fixedGradient = true
    }

    func applyUltraCrispPreset() {
        mode = .connect
        arcsEnabled = false
        margin = 5.0
        externalRadius = 2.0
        opacity = 0.38
        seamEpsilon = 0.0
        barRadius = 3.0
        sleepSegments = 80
        fixedGradient = true
    }
}

@available(iOS 13.0, *)
struct StageControlsView: View {
    @ObservedObject var state: StageControlsState
    var onChange: (() -> Void)?
    var onRandomData: (() -> Void)?

    init(state: StageControlsState,
         onChange: (() -> Void)? = nil,
         onRandomData: (() -> Void)? = nil) {
        self.state = state
        self.onChange = onChange
        self.onRandomData = onRandomData
    }

    var body: some View {
        VStack(spacing: 12) {
            // Mode
            LabeledRow(title: "Mode") {
                Picker("Mode", selection: $state.mode) {
                    Text("connect").tag(StageControlsState.Mode.connect)
                    Text("dilate").tag(StageControlsState.Mode.dilate)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            // Arcs
            LabeledRow(title: "Arcs") {
                Toggle("", isOn: $state.arcsEnabled)
                    .labelsHidden()
            }

            // Arcs Mode
            LabeledRow(title: "ArcsMode") {
                Picker("ArcsMode", selection: $state.arcsMode) {
                    Text("concave").tag(StageControlsState.ArcsMode.concave)
                    Text("convex").tag(StageControlsState.ArcsMode.convex)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            // Sliders
            SliderRow(title: "BarRadius", value: $state.barRadius, range: 0...20, isInt: false)
            SliderRow(title: "Margin", value: $state.margin, range: 0...20, isInt: false)
            SliderRow(title: "ExternalRadius", value: $state.externalRadius, range: 0...30, isInt: false)
            SliderRow(title: "Opacity", value: $state.opacity, range: 0...1, isInt: false)
            SliderRow(title: "SeamEpsilon", value: $state.seamEpsilon, range: 0...2, isInt: false)
            SliderRow(title: "SleepSegments", value: Binding<Float>(
                get: { Float(state.sleepSegments) },
                set: { state.sleepSegments = Int($0.rounded()) }
            ), range: 8...100, isInt: true)

            // Fixed Gradient
            LabeledRow(title: "Fixed Blue Gradient") {
                Toggle("", isOn: $state.fixedGradient)
                    .labelsHidden()
            }

            // Preset Buttons
            HStack(spacing: 8) {
                Button("ECharts Fluid") { state.applyFluidPreset(); onChange?() }
                Button("ECharts Parity") { state.applyParityPreset(); onChange?() }
                Button("Safe Dilate") { state.applySafeDilatePreset(); onChange?() }
                Button("Ultra-crisp") { state.applyUltraCrispPreset(); onChange?() }
                Button("Random Data") { onRandomData?(); onChange?() }
            }
            // Use default button style for iOS 13 compatibility
        }
        .padding(.vertical, 12)
        .onReceive(state.objectWillChange) { _ in
            onChange?()
        }
    }
}

@available(iOS 13.0, *)
private struct LabeledRow<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 110, alignment: .leading)
            content
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
    }
}

@available(iOS 13.0, *)
private struct SliderRow: View {
    let title: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    let isInt: Bool

    var body: some View {
        LabeledRow(title: title) {
            HStack(spacing: 8) {
                Slider(value: $value, in: range)
                Text(displayValue)
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 60, alignment: .trailing)
            }
        }
    }

    private var displayValue: String {
        if isInt { return String(Int(value.rounded())) }
        return String(format: "%.2f", value)
    }
}
