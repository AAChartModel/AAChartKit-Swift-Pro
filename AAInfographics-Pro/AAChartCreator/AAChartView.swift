//
//  AAChartView.swift
//  AAChartKit-Swift
//
//  Created by An An on 2017/5/23.
//  Copyright © 2017年 An An . All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 *  🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit-Swift/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/12302132/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

import WebKit

@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
@objc public protocol AAChartViewDelegate: NSObjectProtocol {
    @objc optional func aaChartViewDidFinishLoad(_ aaChartView: AAChartView)
    @objc optional func aaChartViewDidFinishEvaluate(_ aaChartView: AAChartView)
    @objc optional func aaChartView(_ aaChartView: AAChartView, clickEventMessage: AAClickEventMessageModel)
    @objc optional func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel)
}


@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class AAEventMessageModel: NSObject {
    public var name: String?
    public var x: Float?
    public var y: Float?
    public var category: String?
    public var offset: [String: Any]?
    public var index: Int?
    
    required override init() {
        
    }
}


@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class AAClickEventMessageModel: AAEventMessageModel {}

@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class AAMoveOverEventMessageModel: AAEventMessageModel {}


/// Refer to: https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class AALeakAvoider : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    
    public init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}


@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class AAChartView: WKWebView {
    let kUserContentMessageNameClick = "click"
    let kUserContentMessageNameMouseOver = "mouseover"
    
    private var clickEventEnabled: Bool?
    private var touchEventEnabled: Bool?
    private var beforeDrawChartJavaScript: String?
    private var afterDrawChartJavaScript: String?
    
    private weak var _delegate: AAChartViewDelegate?
    public weak var delegate: AAChartViewDelegate? {
        set {
            assert(optionsJson == nil, "You should set the delegate before drawing the chart") //To Make sure the clickEventEnabled and touchEventEnabled properties are working correctly
            
            _delegate = newValue
            if newValue?.responds(to: #selector(AAChartViewDelegate.aaChartView(_:clickEventMessage:))) == true {
                clickEventEnabled = true
                addClickEventMessageHandler()
            }
            if newValue?.responds(to: #selector(AAChartViewDelegate.aaChartView(_:moveOverEventMessage:))) == true {
                touchEventEnabled = true
                addMouseOverEventMessageHandler()
            }
        }
        
        get {
            _delegate
        }
    }
    
    // MARK: - Setter Method
#if os(iOS)
    public var isScrollEnabled: Bool? {
        willSet {
            scrollView.isScrollEnabled = newValue!
        }
    }
#endif
    
    
    public var isClearBackgroundColor: Bool? {
        willSet {
#if os(iOS)
            if newValue! == true {
                backgroundColor = .clear
                isOpaque = false
            } else {
                backgroundColor = .white
                isOpaque = true
            }
#elseif os(macOS)
            if newValue! == true {
                layer?.backgroundColor = .clear
                layer?.isOpaque = false
            } else {
                layer?.backgroundColor = .white
                layer?.isOpaque = true
            }
#endif
        }
    }
    
    public var isSeriesHidden: Bool? {
        willSet {
            if optionsJson != nil {
                let jsStr = "setChartSeriesHidden('\(newValue!)')"
                safeEvaluateJavaScriptString(jsStr)
            }
        }
    }
    
    /// Content width of AAChartView
    public var contentWidth: CGFloat? {
        willSet {
            if optionsJson != nil {
                let jsStr = "setTheChartViewContentWidth('\(newValue!)')"
                safeEvaluateJavaScriptString(jsStr)
            }
        }
    }
    
    /// Content height of AAChartView
    public var contentHeight: CGFloat? {
        willSet {
            if optionsJson != nil {
                let jsStr = "setTheChartViewContentHeight('\(newValue!)')"
                safeEvaluateJavaScriptString(jsStr)
            }
        }
    }
    
    internal var optionsJson: String?
    
    private var requiredPluginPaths: Set<String> = []
    private var loadedPluginPaths: Set<String> = [] // Keep track of loaded plugins
    
    public var userPluginPaths: Set<String> = []
    
    // Static mapping from chart type rawValue to script names
    private static let chartTypeScriptMapping: [String: [String]] = [
        // --- Flow & Relationship Charts ---
        AAChartType.sankey.rawValue          : ["AASankey"],
        AAChartType.dependencywheel.rawValue : ["AASankey", "AADependency-Wheel"],
        AAChartType.networkgraph.rawValue    : ["AANetworkgraph"],
        AAChartType.organization.rawValue    : ["AASankey", "AAOrganization"],
        AAChartType.arcdiagram.rawValue      : ["AASankey", "AAArc-Diagram"],
        AAChartType.venn.rawValue            : ["AAVenn"], // Can also be considered set theory
        
        // --- Hierarchical Charts ---
        AAChartType.treemap.rawValue         : ["AATreemap"],
        AAChartType.sunburst.rawValue        : ["AASunburst"],
        AAChartType.flame.rawValue           : ["AAFlame"], // Often used for profiling/hierarchy
        
        // --- Distribution & Comparison Charts ---
        AAChartType.variablepie.rawValue     : ["AAVariable-Pie"],
        AAChartType.variwide.rawValue        : ["AAVariwide"],
        AAChartType.dumbbell.rawValue        : ["AADumbbell"],
        AAChartType.lollipop.rawValue        : ["AADumbbell", "AALollipop"],
        AAChartType.histogram.rawValue       : ["AAHistogram-Bellcurve"],
        AAChartType.bellcurve.rawValue       : ["AAHistogram-Bellcurve"],
        AAChartType.bullet.rawValue          : ["AABullet"], // Can also be gauge/indicator
        
        // --- Heatmap & Matrix Charts ---
        AAChartType.heatmap.rawValue         : ["AAHeatmap"],
        AAChartType.tilemap.rawValue         : ["AAHeatmap", "AATilemap"],
        
        // --- Time, Range & Stream Charts ---
        AAChartType.streamgraph.rawValue     : ["AAStreamgraph"],
        AAChartType.xrange.rawValue          : ["AAXrange"],
        AAChartType.timeline.rawValue        : ["AATimeline"],
        
        // --- Gauge & Indicator Charts ---
        AAChartType.solidgauge.rawValue      : ["AASolid-Gauge"],
        // AAChartType.bullet is listed under Distribution/Comparison but fits here too
        
        // --- Specialized & Other Charts ---
        AAChartType.vector.rawValue          : ["AAVector"],
        AAChartType.item.rawValue            : ["AAItem-Series"], // Specific series type
        AAChartType.windbarb.rawValue        : ["AAWindbarb"], // Meteorological
        AAChartType.wordcloud.rawValue       : ["AAWordcloud"], // Text visualization
    ]
    
    // MARK: - Initialization
    override private init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        uiDelegate = self
        navigationDelegate = self
    }
    
    convenience public init() {
        let configuration = WKWebViewConfiguration()
        self.init(frame: .zero, configuration: configuration)
    }
    
    required public convenience init?(coder aDecoder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        self.init(frame: .zero, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    internal func loadAllPluginsAndDrawChart() {
        // Inner recursive function to load scripts sequentially
        func loadScripts(scriptsToLoad: Set<String>, index: Int, successfullyLoaded: Set<String>, completion: @escaping (Set<String>) -> Void) {
            // Base case: All scripts in the set attempted
            if index >= scriptsToLoad.count {
#if DEBUG
                if !scriptsToLoad.isEmpty { // Only log if we actually tried loading something
                    print("✅ \(successfullyLoaded.count) out of \(scriptsToLoad.count) new plugin scripts evaluated successfully.")
                }
#endif
                completion(successfullyLoaded) // Return the set of successfully loaded scripts
                return
            }
            
            // Get the script path for the current index
            let path = scriptsToLoad[scriptsToLoad.index(scriptsToLoad.startIndex, offsetBy: index)]
            let scriptName = (path as NSString).lastPathComponent // Extract filename for logging
            
            do {
                // Read the script content
                let jsString = try String(contentsOfFile: path, encoding: .utf8)
                // Evaluate the script
                evaluateJavaScript(jsString) { result, error in
                    var currentSuccessSet = successfullyLoaded
                    if let error = error {
#if DEBUG
                        print("❌ Error evaluating new plugin script '\(scriptName)' (index \(index)): \(error)")
#endif
                        // Continue to the next script even if this one fails
                        loadScripts(scriptsToLoad: scriptsToLoad, index: index + 1, successfullyLoaded: currentSuccessSet, completion: completion)
                    } else {
#if DEBUG
                        print("✅ New plugin script '\(scriptName)' (index \(index)) evaluated.")
#endif
                        currentSuccessSet.insert(path) // Add successfully evaluated script path
                        // Recursively load the next script
                        loadScripts(scriptsToLoad: scriptsToLoad, index: index + 1, successfullyLoaded: currentSuccessSet, completion: completion)
                    }
                }
            } catch {
#if DEBUG
                print("❌ Failed to load plugin script file '\(scriptName)' (index \(index)): \(error)")
#endif
                // Continue to the next script even if loading fails
                loadScripts(scriptsToLoad: scriptsToLoad, index: index + 1, successfullyLoaded: successfullyLoaded, completion: completion)
            }
        }
        
        // --- Main logic of loadAllPluginsAndDrawChart ---
        
        // 1. Determine the total set of required plugins for the current chart options
        let totalRequiredPluginsSet = requiredPluginPaths.union(userPluginPaths)
        
        if totalRequiredPluginsSet.isEmpty {
#if DEBUG
            print("ℹ️ No additional plugins needed for the current chart options.")
#endif
            drawChart()
            return
        }
        
        // 2. Determine which plugins are required but not yet loaded
        let pluginsToLoad = totalRequiredPluginsSet.subtracting(loadedPluginPaths)
        
        // 3. Check if any new plugins need to be loaded
        if pluginsToLoad.isEmpty {
#if DEBUG
            print("ℹ️ All required plugins (count: \(totalRequiredPluginsSet.count)) already loaded.")
#endif
            drawChart() // All necessary plugins are already loaded, just draw the chart
            return
        }
        
        // 4. Load the necessary new plugins
#if DEBUG
        print("ℹ️ Loading \(pluginsToLoad.count) new plugin scripts...")
#endif
        
        loadScripts(scriptsToLoad: pluginsToLoad, index: 0, successfullyLoaded: Set<String>()) { newlyLoadedPlugins in
            // 5. Update the set of all loaded plugins
            self.loadedPluginPaths.formUnion(newlyLoadedPlugins)
            
#if DEBUG
            if newlyLoadedPlugins.count < pluginsToLoad.count {
                print("⚠️ Failed to evaluate one or more new plugin scripts. Chart drawing may be affected.")
            }
            print("ℹ️ Total loaded plugins count: \(self.loadedPluginPaths.count)")
#endif
            
            // 6. Draw the chart after attempting to load new plugins
            self.drawChart()
        }
    }
    
    internal func drawChart() {
        let jsStr = "loadTheHighChartView('\(optionsJson ?? "")','\(contentWidth ?? 0)','\(contentHeight ?? 0)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    internal func safeEvaluateJavaScriptString (_ jsString: String) {
        if optionsJson == nil {
#if DEBUG
            print("💀💀💀AAChartView did not finish loading!!!")
#endif
            return
        }
        
        evaluateJavaScript(jsString, completionHandler: { (item, error) in
#if DEBUG
            if error != nil {
                let objcError = error! as NSError
                let errorUserInfo = objcError.userInfo
                
                let errorInfo =
                """
                
                ☠️☠️💀☠️☠️WARNING!!!!!!!!!!!!!!!!!!!! JS WARNING !!!!!!!!!!!!!!!!!!!!WARNING☠️☠️💀☠️☠️
                ------------------------------------------------------------------------------------------
                code = \(objcError.code);
                domain = \(objcError.domain);
                userInfo = {
                    NSLocalizedDescription = "\(errorUserInfo["NSLocalizedDescription"] ?? "")";
                    WKJavaScriptExceptionColumnNumber = \(errorUserInfo["WKJavaScriptExceptionColumnNumber"] ?? "");
                    WKJavaScriptExceptionLineNumber = \(errorUserInfo["WKJavaScriptExceptionLineNumber"]  ?? "");
                    WKJavaScriptExceptionMessage = \(errorUserInfo["WKJavaScriptExceptionMessage"] ?? "");
                    WKJavaScriptExceptionSourceURL = \(errorUserInfo["WKJavaScriptExceptionSourceURL"] ?? "");
                }
                ------------------------------------------------------------------------------------------
                ☠️☠️💀☠️☠️WARNING!!!!!!!!!!!!!!!!!!!! JS WARNING !!!!!!!!!!!!!!!!!!!!WARNING☠️☠️💀☠️☠️
                
                """
                print(errorInfo)
            }
#endif
            
            self.delegate?.aaChartViewDidFinishEvaluate?(self)
        })
    }
    
    private func configurePlotOptionsSeriesPointEvents(_ aaOptions: AAOptions) {
        if aaOptions.plotOptions == nil {
            aaOptions.plotOptions = AAPlotOptions().series(AASeries().point(AAPoint().events(AAPointEvents())))
        } else if aaOptions.plotOptions?.series == nil {
            aaOptions.plotOptions?.series = AASeries().point(AAPoint().events(AAPointEvents()))
        } else if aaOptions.plotOptions?.series?.point == nil {
            aaOptions.plotOptions?.series?.point = AAPoint().events(AAPointEvents())
        } else if aaOptions.plotOptions?.series?.point?.events == nil {
            aaOptions.plotOptions?.series?.point?.events = AAPointEvents()
        }
    }
    
    //向 pluginsArray 数组中添加插件脚本路径(避免重复添加)
    private func addChartPluginScriptsArrayForProTypeChart(_ chartType: String?) {
        guard let type = chartType, let scriptNames = Self.chartTypeScriptMapping[type] else {
            return
        }
        
        scriptNames.forEach { scriptName in
            let scriptPath = generateScriptPathWithScriptName(scriptName)
            requiredPluginPaths.insert(scriptPath) // Directly insert into the Set
        }
        
#if DEBUG
        print("🔌 requiredPluginPaths after checking pro type chart '\(type)': \(requiredPluginPaths)")
#endif
    }
    
    private func addChartPluginScriptsArrayForAAOptions(_ aaOptions: AAOptions?) {
        if aaOptions?.chart?.parallelCoordinates == true {
            let scriptPath = generateScriptPathWithScriptName("AAParallel-coordinates")
            requiredPluginPaths.insert(scriptPath) // Directly insert
        }
        if aaOptions?.data != nil {
            let scriptPath = generateScriptPathWithScriptName("AAData")
            requiredPluginPaths.insert(scriptPath) // Directly insert
        }
        
#if DEBUG
        print("🔌 requiredPluginPaths after checking AAOptions: \(requiredPluginPaths)")
#endif
    }
    
    //判断 AAOptions 是否为除了基础类型之外的特殊类型
    private func isSpecialProTypeChart(_ aaOptions: AAOptions) {
        addChartPluginScriptsArrayForAAOptions(aaOptions)
        
        let aaChartType = aaOptions.chart?.type
        addChartPluginScriptsArrayForProTypeChart(aaChartType)
        
        if let seriesArray = aaOptions.series {
            for aaSeriesElement in seriesArray {
                if let finalSeriesElement = aaSeriesElement as? AASeriesElement,
                   let aaSeriesType = finalSeriesElement.type {
                    addChartPluginScriptsArrayForProTypeChart(aaSeriesType)
                }
            }
        }
    }
    
    private func generateScriptPathWithScriptName(_ scriptName: String) -> String {
        let path = BundlePathLoader()
            .path(forResource: scriptName,
                  ofType: "js",
                  inDirectory: "AAJSFiles.bundle/AAModules")
        let urlStr = NSURL.fileURL(withPath: path!)
        
        //        //打印 urlStr 路径
        //        print("🫁🫁🫁urlStr: \(urlStr)")
        //
        //        //打印 urlStr 路径文件的内容
        //        let jsContent = try? String(contentsOf: urlStr)
        //        print(try? jsContent ?? "")
        
        let jsPluginPath = urlStr.path
        return jsPluginPath
    }
    
#if DEBUG
    private func printOptionsJSONInfo(_ aaOptions: AAOptions) {
        // --- 数据量截断处理 ---
        // 检查 series 是否为 [AASeriesElement] 类型且不为空
        if let seriesElements = aaOptions.series as? [AASeriesElement],
           !seriesElements.isEmpty {
            
            // 检查1: 单个 series 的 data 数组元素个数是否超过 1000
            var didTruncateData = false
            for seriesElement in seriesElements {
                // 使用可选绑定确保 data 存在
                if let data = seriesElement.data, data.count > 1000 {
                    // 截取前 1000 个元素
                    // 注意：这里直接修改了 aaOptions 中的 seriesElement.data，仅影响后续的打印
                    seriesElement.data = Array(data.prefix(1000))
                    didTruncateData = true
                }
            }
            // 如果进行了数据截断，打印警告信息
            if didTruncateData {
                print("💊 Warning: Data array element count more than 1000, only the first 1000 data elements will be displayed in the console!!!")
                print("💊 警告: 数据数组元素个数超过 1000 个, 只打印前 1000 个数据元素到控制台!!!")
            }
            
            // 检查2: series 数组本身元素个数是否超过 10
            if seriesElements.count > 10 {
                // 截取前 10 个 series 元素
                // 注意：这里直接修改了 aaOptions.series，仅影响后续的打印
                aaOptions.series = Array(seriesElements.prefix(10))
                // 打印警告信息
                print("💊 Warning: Series element count more than 10, only the first 10 elements will be displayed in the console!!!")
                print("💊 警告: 系列元素个数超过 10 个, 只打印前 10 个元素到控制台!!!")
            }
        }
        
        // --- JSON 打印 ---
        // 将（可能已被截断的）aaOptions 转换为字典
        let modelJsonDic = aaOptions.toDic()
        do {
            // 尝试序列化为 JSON Data
            let jsonData = try JSONSerialization.data(withJSONObject: modelJsonDic, options: .prettyPrinted)
            // 尝试将 JSON Data 转换为 UTF8 字符串，并安全解包
            if let prettyPrintedModelJson = String(data: jsonData, encoding: .utf8) {
                print("""
                            -----------🖨🖨🖨 console log AAOptions JSON information of AAChartView 🖨🖨🖨-----------:
                            \(prettyPrintedModelJson)
                            """)
            } else {
                print("⚠️ Warning: Could not convert JSON data to UTF8 string for logging.")
            }
        } catch {
            // 捕获并打印序列化错误
            print("⚠️ Warning: Could not serialize AAOptions to JSON for logging: \(error)")
        }
    }
#endif
    
    internal func configureOptionsJsonStringWithAAOptions(_ aaOptions: AAOptions) {
        // Initialize the Set from the optional array, ensuring uniqueness
        requiredPluginPaths = Set(aaOptions.pluginsArray ?? [])
        
        // Determine and add required scripts based on options and chart/series types
        isSpecialProTypeChart(aaOptions)
        
        if aaOptions.beforeDrawChartJavaScript != nil {
            beforeDrawChartJavaScript = aaOptions.beforeDrawChartJavaScript
            aaOptions.beforeDrawChartJavaScript = nil
        }
        
        if aaOptions.afterDrawChartJavaScript != nil {
            afterDrawChartJavaScript = aaOptions.afterDrawChartJavaScript
            aaOptions.afterDrawChartJavaScript = nil
        }
        
        if isClearBackgroundColor == true {
            aaOptions.chart?.backgroundColor = AAColor.clear
        }
        
        if clickEventEnabled == true {
            aaOptions.clickEventEnabled = true
        }
        if touchEventEnabled == true {
            aaOptions.touchEventEnabled = true
        }
        if clickEventEnabled == true || touchEventEnabled == true {
            configurePlotOptionsSeriesPointEvents(aaOptions)
        }
        
        optionsJson = aaOptions.toJSON()
        
#if DEBUG
        printOptionsJSONInfo(aaOptions)
#endif
    }
    
    private func addClickEventMessageHandler() {
        configuration.userContentController.removeScriptMessageHandler(forName: kUserContentMessageNameClick)
        configuration.userContentController.add(AALeakAvoider.init(delegate: self), name: kUserContentMessageNameClick)
    }
    
    private func addMouseOverEventMessageHandler() {
        configuration.userContentController.removeScriptMessageHandler(forName: kUserContentMessageNameMouseOver)
        configuration.userContentController.add(AALeakAvoider.init(delegate: self), name: kUserContentMessageNameMouseOver)
    }
    
    
    deinit {
        configuration.userContentController.removeAllUserScripts()
        NotificationCenter.default.removeObserver(self)
#if DEBUG
        print("👻👻👻 AAChartView instance \(self) has been destroyed!")
#endif
    }
}


// MARK: - WKUIDelegate
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView: WKUIDelegate {
    open func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
#if os(iOS)
        let alertController = UIAlertController(title: "JS WARNING", message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(okayAction)
        
        guard let presentingViewController = self.nextUIViewController() else {
            print("Unable to present UIAlertController from AAChartView. Completing JavaScript alert handler.")
            completionHandler()
            return
        }
        
        presentingViewController.present(alertController, animated: true, completion: nil)
        
#elseif os(macOS)
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "JS WARNING"
        alert.informativeText = message
        alert.addButton(withTitle: "Okay")
        
        alert.beginSheetModal(for: NSApplication.shared.mainWindow!) { (response) in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                completionHandler()
            }
        }
#endif
    }
    
#if os(iOS)
    private func nextUIViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
#endif
    
}


// MARK: - WKNavigationDelegate
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView:  WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadAllPluginsAndDrawChart()
        delegate?.aaChartViewDidFinishLoad?(self)
    }
}


// MARK: - WKScriptMessageHandler
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == kUserContentMessageNameClick {
            let messageBody = message.body as! [String: Any]
            let clickEventMessageModel = getEventMessageModel(messageBody: messageBody, eventType: AAClickEventMessageModel.self)
            delegate?.aaChartView?(self, clickEventMessage: clickEventMessageModel)
        } else if message.name == kUserContentMessageNameMouseOver {
            let messageBody = message.body as! [String: Any]
            let moveOverEventMessageModel = getEventMessageModel(messageBody: messageBody, eventType: AAMoveOverEventMessageModel.self)
            delegate?.aaChartView?(self, moveOverEventMessage: moveOverEventMessageModel)
        }
    }
}


// MARK: - Event Message Model
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView {
    private func getEventMessageModel<T: AAEventMessageModel>(messageBody: [String: Any], eventType: T.Type) -> T {
        let eventMessageModel = T()
        eventMessageModel.name = messageBody["name"] as? String
        eventMessageModel.x = getFloatValue(messageBody["x"])
        eventMessageModel.y = getFloatValue(messageBody["y"])
        eventMessageModel.category = messageBody["category"] as? String
        eventMessageModel.offset = messageBody["offset"] as? [String: Any]
        eventMessageModel.index = messageBody["index"] as? Int
        return eventMessageModel
    }
    
    private func getFloatValue<T>(_ value: T?) -> Float? {
        switch value {
        case let value as Float: return value
        case let value as Int: return Float(value)
        case let value as Double: return Float(value)
        case let value as String: return Float(value)
        default:
            return nil
        }
    }
}


