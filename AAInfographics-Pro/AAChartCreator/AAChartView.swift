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
    
    private var modulesJSPluginsArray: [String] = []
    
    private var optionsJson: String?
    public var jsPluginsArray: [String] = []
    
    // Static mapping from chart type rawValue to script names
    private static let chartTypeScriptMapping: [String: [String]] = [
        AAChartType.sankey.rawValue: ["AASankey"],
        AAChartType.dependencywheel.rawValue: ["AASankey", "AADependency-Wheel"],
        AAChartType.variablepie.rawValue: ["AAVariable-Pie"],
        AAChartType.treemap.rawValue: ["AATreemap"],
        AAChartType.variwide.rawValue: ["AAVariwide"],
        AAChartType.sunburst.rawValue: ["AASunburst"],
        AAChartType.heatmap.rawValue: ["AAHeatmap"],
        AAChartType.streamgraph.rawValue: ["AAStreamgraph"],
        AAChartType.venn.rawValue: ["AAVenn"],
        AAChartType.tilemap.rawValue: ["AAHeatmap", "AATilemap"],
        AAChartType.dumbbell.rawValue: ["AADumbbell"],
        AAChartType.lollipop.rawValue: ["AADumbbell", "AALollipop"],
        AAChartType.xrange.rawValue: ["AAXrange"],
        AAChartType.vector.rawValue: ["AAVector"],
        AAChartType.histogram.rawValue: ["AAHistogram-Bellcurve"],
        AAChartType.bellcurve.rawValue: ["AAHistogram-Bellcurve"],
        AAChartType.timeline.rawValue: ["AATimeline"],
        AAChartType.item.rawValue: ["AAItem-Series"],
        AAChartType.windbarb.rawValue: ["AAWindbarb"],
        AAChartType.networkgraph.rawValue: ["AANetworkgraph"],
        AAChartType.wordcloud.rawValue: ["AAWordcloud"],
        AAChartType.solidgauge.rawValue: ["AASolid-Gauge"],
        AAChartType.bullet.rawValue: ["AABullet"],
        AAChartType.organization.rawValue: ["AASankey", "AAOrganization"],
        AAChartType.arcdiagram.rawValue: ["AASankey", "AAArc-Diagram"],
        AAChartType.flame.rawValue: ["AAFlame"],
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
   
    
    private func loadAllPluginsAndDrawChart() {
        func loadScripts(from scriptsArray: [String], index: Int, completion: @escaping (Bool) -> Void) {
            if index >= scriptsArray.count {
                // 所有脚本已加载完成
                print("✅✅✅ All plugin scripts loaded successfully")
                completion(true)
                return
            }
            
            let path = scriptsArray[index]
        

            do {
                let jsString = try String(contentsOfFile: path, encoding: .utf8)
                evaluateJavaScript(jsString) { result, error in
                    if let error = error {
                        print("❌❌❌ Error evaluating plugin JavaScript at index \(index): \(error), error JavaScript name: \(path)")
                        completion(false) // 或者可以选择忽略错误并继续加载下一个脚本
                    } else {
                        print("✅✅✅ Plugin JavaScript at index \(index) evaluated successfully, JavaScript name: \(path)")
                        loadScripts(from: scriptsArray, index: index + 1, completion: completion)
                    }
                }
            } catch {
                print("❌❌❌ Failed to load plugin JavaScript at index \(index): \(error), error JavaScript name: \(path)")
                completion(false) // 或者可以选择忽略错误并继续加载下一个脚本
            }
        }
        
        
        if modulesJSPluginsArray.isEmpty && jsPluginsArray.isEmpty {
            drawChart()
            return
        }
        
        let totalJSPluginsArray = modulesJSPluginsArray + jsPluginsArray
        loadScripts(from: totalJSPluginsArray, index: 0) { success in
            if success {
                self.drawChart()
            } else {
                print("❌❌❌ Failed to load one or more plugin scripts.")
            }
        }
    }
    
    private func drawChart() {
        let jsStr = "loadTheHighChartView('\(optionsJson ?? "")','\(contentWidth ?? 0)','\(contentHeight ?? 0)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    private func safeEvaluateJavaScriptString (_ jsString: String) {
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

    // Helper function to generate script path and append uniquely
    private func appendUniqueScript(scriptName: String) {
        let scriptPath = generateScriptPathWithScriptName(scriptName)
        if !modulesJSPluginsArray.contains(scriptPath) {
            modulesJSPluginsArray.append(scriptPath)
        }
    }

    //向 pluginsArray 数组中添加插件脚本路径(避免重复添加)
    private func addChartPluginScriptsArrayForProTypeChart(_ chartType: String?) {
        guard let type = chartType, let scriptNames = Self.chartTypeScriptMapping[type] else {
            return
        }

        scriptNames.forEach { scriptName in
            appendUniqueScript(scriptName: scriptName)
        }

        #if DEBUG
        print("🔌🔌🔌pluginsArray after checking pro type chart '\(type)': \(modulesJSPluginsArray)")
        #endif
    }

    private func addChartPluginScriptsArrayForAAOptions(_ aaOptions: AAOptions?) {
        if aaOptions?.chart?.parallelCoordinates == true {
            appendUniqueScript(scriptName: "AAParallel-coordinates")
        }
        if aaOptions?.data != nil {
            appendUniqueScript(scriptName: "AAData")
        }

        #if DEBUG
        print("🔌🔌🔌pluginsArray after checking AAOptions: \(modulesJSPluginsArray)")
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
        //打印 urlStr 路径
        print("🫁🫁🫁urlStr: \(urlStr)")

        //打印 urlStr 路径文件的内容
        let jsContent = try? String(contentsOf: urlStr)
        print(try? jsContent ?? "")
        let jsPluginPath = urlStr.path
        return jsPluginPath
    }
    
    private func configureOptionsJsonStringWithAAOptions(_ aaOptions: AAOptions) {
        modulesJSPluginsArray = aaOptions.pluginsArray ?? []
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
        //如果 series 数组中的 AASeriesElement 对象的 data 数组元素个数超过 1000 个,
        //则只打印前 1000 个元素,避免控制台输出太多导致卡顿
        //同时添加警告提醒开发者注意数组元素个数超出 1000 个的问题
        if aaOptions.series != nil && aaOptions.series!.count > 0 && aaOptions.series is [AASeriesElement] {
            for  seriesElement in aaOptions.series as! [AASeriesElement] {
                if seriesElement.data != nil {
                    if seriesElement.data!.count > 1000 {
                        let dataArr = seriesElement.data![0...999]
                        seriesElement.data = Array(dataArr)
                        //打印⚠️信息, 中英对照
                        print("💊💊💊Warning: Data array element count more than 1000, only the first 1000 data elements will be displayed in the console!!!")
                        print("💊💊💊警告: 数据数组元素个数超过 1000 个, 只打印前 1000 个数据元素到控制台!!!")
                    }
                }
            }
        }
        
        //如果 series 数组中的 AASeriesElement 对象元素个数超过 10 个,
        //则只打印前 10 个元素,避免控制台输出太多导致卡顿
        //同时添加警告提醒开发者注意数组元素个数超出 10 个的问题
        if aaOptions.series != nil && aaOptions.series!.count > 10 && aaOptions.series is [AASeriesElement] {
            let seriesElementArr = aaOptions.series as! [AASeriesElement]
            let firstTenElementArr = seriesElementArr[0...9]
            aaOptions.series = Array(firstTenElementArr)
            //打印⚠️信息, 中英对照
            print("💊💊💊Warning: Series element count more than 10, only the first 10 elements will be displayed in the console!!!")
            print("💊💊💊警告: 系列元素个数超过 10 个, 只打印前 10 个元素到控制台!!!")
        }
        
        let modelJsonDic = aaOptions.toDic()
        let data = try? JSONSerialization.data(withJSONObject: modelJsonDic, options: .prettyPrinted)
        if data != nil {
            let prettyPrintedModelJson = String(data: data!, encoding: String.Encoding.utf8)
            print("""
                -----------🖨🖨🖨 console log AAOptions JSON information of AAChartView 🖨🖨🖨-----------:
                \(prettyPrintedModelJson!)
                """)
        }
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


// MARK: - Configure Chart View Content With AAChartModel
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView {
    /// Function of drawing chart view
    ///
    /// - Parameter aaChartModel: The instance object of AAChartModel
    public func aa_drawChartWithChartModel(_ aaChartModel: AAChartModel) {
        let aaOptions = aaChartModel.aa_toAAOptions()
        aa_drawChartWithChartOptions(aaOptions)
    }
    
    /// Function of only refresh the chart data after the chart has been rendered
    /// Refer to https://api.highcharts.com/class-reference/Highcharts.Chart#update
    ///
    /// - Parameter chartModelSeries: chart model series  array
    /// - Parameter animation: enable animation effect or not
    public func aa_onlyRefreshTheChartDataWithChartModelSeries(_ chartModelSeries: [AASeriesElement], animation: Bool = true) {
        aa_onlyRefreshTheChartDataWithChartOptionsSeries(chartModelSeries, animation: animation)
    }
    
    ///  Function of refreshing whole chart view content after the chart has been rendered
    ///
    /// - Parameter aaChartModel: The instance object of AAChartModel
    public func aa_refreshChartWholeContentWithChartModel(_ aaChartModel: AAChartModel) {
        let aaOptions = aaChartModel.aa_toAAOptions()
        aa_refreshChartWholeContentWithChartOptions(aaOptions)
    }
}


// MARK: - Configure Chart View Content With AAOptions
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView {
    /// Function of drawing chart view
    ///
    /// - Parameter aaOptions: The instance object of AAOptions model
    public func aa_drawChartWithChartOptions(_ aaOptions: AAOptions) {
        if optionsJson == nil {
            configureOptionsJsonStringWithAAOptions(aaOptions)
            let path = BundlePathLoader()
                .path(forResource: "AAChartView",
                      ofType: "html",
                      inDirectory: "AAJSFiles.bundle")
            let urlStr = NSURL.fileURL(withPath: path!)
            //打印 urlStr 路径文件的内容
//            print(try? String(contentsOf: urlStr) ?? "")
            let urlRequest = NSURLRequest(url: urlStr) as URLRequest
            load(urlRequest)
        } else {
            aa_refreshChartWholeContentWithChartOptions(aaOptions)
        }
    }
    
    /// Function of only refresh the chart data after the chart has been rendered
    /// Refer to https://api.highcharts.com/class-reference/Highcharts.Chart#update
    ///
    /// - Parameter chartOptionsSeries: chart options series  array
    /// - Parameter animation: enable animation effect or not
    public func aa_onlyRefreshTheChartDataWithChartOptionsSeries(_ chartOptionsSeries: [AASeriesElement], animation: Bool = true) {
        var seriesElementDicArr = [[String: Any]]()
        chartOptionsSeries.forEach { (aaSeriesElement) in
            seriesElementDicArr.append(aaSeriesElement.toDic())
        }
        
        let str = getJSONStringFromArray(array: seriesElementDicArr)
        let jsStr = "onlyRefreshTheChartDataWithSeries('\(str)','\(animation)');"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    ///  Function of refreshing whole chart view content after the chart has been rendered
    ///
    /// - Parameter aaOptions: The instance object of AAOptions model
    public func aa_refreshChartWholeContentWithChartOptions(_ aaOptions: AAOptions) {
        configureOptionsJsonStringWithAAOptions(aaOptions)
        loadAllPluginsAndDrawChart()
    }
}


// MARK: - Additional update Chart View Content methods
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView {
    /// A common chart update function
    /// (you can update any chart element) to open, close, delete, add, resize, reformat, etc. elements in the chart.
    /// Refer to https://api.highcharts.com/highcharts#Chart.update
    ///
    /// It should be noted that when updating the array configuration,
    /// for example, when updating configuration attributes including arrays such as xAxis, yAxis, series, etc., the updated data will find existing objects based on id and update them. If no id is configured or passed If the id does not find the corresponding object, the first element of the array is updated. Please refer to this example for details.
    ///
    /// In a responsive configuration, the response of the different rules responsive.rules is actually calling chart.update, and the updated content is configured in chartOptions.
    ///
    /// - Parameter options: A configuration object for the new chart options as defined in the options section of the API.
    /// - Parameter redraw: Whether to redraw after updating the chart, the default is true
    public func aa_updateChart(options: AAObject, redraw: Bool) {
        let isOptionsClass: Bool = options is AAOptions
        let optionsDic = options.toDic()
        let finalOptionsDic: [String : Any]!
        
        if isOptionsClass == true {
            finalOptionsDic = optionsDic
        } else {
            var classNameStr = options.classNameString
            if classNameStr.contains(".") {
                classNameStr = classNameStr.components(separatedBy: ".")[1];
            }
            
            classNameStr = classNameStr.replacingOccurrences(of: "AA", with: "")
            
            //convert first character to be lowercase string
            let firstChar = classNameStr.prefix(1)
            let lowercaseFirstChar = firstChar.lowercased()
            let index = classNameStr.index(classNameStr.startIndex, offsetBy: 1)
            classNameStr = String(classNameStr.suffix(from: index))
            let finalClassNameStr = lowercaseFirstChar + classNameStr
            finalOptionsDic = [finalClassNameStr: optionsDic as Any]
        }
        
        #if DEBUG
        let data = try? JSONSerialization.data(withJSONObject: finalOptionsDic as Any, options: .prettyPrinted)
        if data != nil {
            let prettyPrintedModelJson = String(data: data!, encoding: String.Encoding.utf8)
            print("""

                -----------📊🔄🖨 console log AAOptions JSON information of advanced updating 🖨🔄📊-----------:
                \(prettyPrintedModelJson!)

                """)
        }
        #endif
                
        let optionsStr = getJSONStringFromDictionary(dictionary: finalOptionsDic)
        let jsStr = "updateChart('\(optionsStr)','\(redraw)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    public func aa_addPointToChartSeriesElement(elementIndex: Int, options: Any) {
        aa_addPointToChartSeriesElement(
            elementIndex: elementIndex,
            options: options,
            shift: true
        )
    }
    
    public func aa_addPointToChartSeriesElement(
        elementIndex: Int,
        options: Any,
        shift: Bool
    ) {
        aa_addPointToChartSeriesElement(
            elementIndex: elementIndex,
            options: options,
            redraw: true,
            shift: shift,
            animation: true
        )
    }
    
    /// Add a new point to the data column after the chart has been rendered.
    /// The new point can be the last point, or it can be placed in the corresponding position given the X value (first, middle position, depending on the x value)
    /// Refer to https://api.highcharts.com/highcharts#Series.addPoint
    ///
    /// - Parameter elementIndex: The specific series element
    /// - Parameter options: The configuration of the data point can be a single value, indicating the y value of the data point; it can also be an array containing x and y values; it can also be an object containing detailed data point configuration. For detailed configuration, see series.data.
    /// - Parameter redraw: The default is true, whether to redraw the icon after the operation is completed. When you need to add more than one point, it is highly recommended to set redraw to false and manually call chart.redraw() to redraw the chart after all operations have ended.
    /// - Parameter shift: The default is false. When this property is true, adding a new point will delete the first point in the data column (that is, keep the total number of data points in the data column unchanged). This property is very useful in the inspection chart
    /// - Parameter animation: The default is true, which means that when adding a point, it contains the default animation effect. This parameter can also be passed to the object form containing duration and easing. For details, refer to the animation related configuration.
    public func aa_addPointToChartSeriesElement(
        elementIndex: Int,
        options: Any,
        redraw: Bool,
        shift: Bool,
        animation: Bool
    ) {
        var optionsStr = ""
        if options is Int || options is Float || options is Double {
            optionsStr = "\(options)"
        } else if options is [Any] {
            optionsStr = getJSONStringFromArray(array: options as! [Any])
        } else {
            let aaOption: AAObject = options as! AAObject
            optionsStr = aaOption.toJSON()
        }
    
        let javaScriptStr = "addPointToChartSeries('\(elementIndex)','\(optionsStr)','\(redraw)','\(shift)','\(animation)')"
        safeEvaluateJavaScriptString(javaScriptStr)
    }
    
    /// Add a new group of points to the data column after the chart has been rendered.
    ///
    public func aa_addPointsToChartSeriesArray(
        optionsArr: [Any],
        shift: Bool = true,
        animation: Bool = true
    ) {
        for (index, options) in optionsArr.enumerated() {
            aa_addPointToChartSeriesElement(
                elementIndex: index,
                options: options,
                redraw: false,
                shift: shift,
                animation: false
            )
        }
        
        aa_redraw(animation: animation)
    }
    
    /// Add a new series element to the chart after the chart has been rendered.
    /// Refer to https://api.highcharts.com/highcharts#Chart.addSeries
    ///
    /// - Parameter element: chart series element
    public func aa_addElementToChartSeries(element: AASeriesElement) {
        let elementJson = element.toJSON()
        let pureElementJsonStr = elementJson.aa_toPureJSString()
        let jsStr = "addElementToChartSeriesWithElement('\(pureElementJsonStr)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    /// Remove a specific series element from the chart after the chart has been rendered.
    /// Refer to https://api.highcharts.com/highcharts#Series.remove
    ///
    /// - Parameter elementIndex: chart series element index
    public func aa_removeElementFromChartSeries(elementIndex: Int) {
        let jsStr = "removeElementFromChartSeriesWithElementIndex('\(elementIndex)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    /// Show the series element content with index
    ///
    /// - Parameter elementIndex: elementIndex element index
    public func aa_showTheSeriesElementContentWithSeriesElementIndex(_ elementIndex: NSInteger) {
        let jsStr = "showTheSeriesElementContentWithIndex('\(elementIndex)');"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    ///  Hide the series element content with index
    ///
    /// - Parameter elementIndex: element index
    public func aa_hideTheSeriesElementContentWithSeriesElementIndex(_ elementIndex: NSInteger) {
        let jsStr = "hideTheSeriesElementContentWithIndex('\(elementIndex)');"
        safeEvaluateJavaScriptString(jsStr as String)
    }
    
    ///  Evaluate JavaScript string function body
    ///
    /// - Parameter JSFunctionString: valid JavaScript function body string
    public func aa_evaluateJavaScriptStringFunction(_ JSFunctionString: String) {
        if optionsJson != nil {
            let pureJSFunctionStr = JSFunctionString.aa_toPureJSString()
            let jsFunctionNameStr = "evaluateTheJavaScriptStringFunction('\(pureJSFunctionStr)')"
            safeEvaluateJavaScriptString(jsFunctionNameStr)
        }
    }
    
    /// Update the X axis categories of chart
    /// Refer to https://api.highcharts.com/class-reference/Highcharts.Axis#setCategories
    ///
    /// - Parameters:
    ///   - categories: The X axis categories array
    ///   - redraw: Redraw whole chart or not
    public func aa_updateXAxisCategories(_ categories: [String], redraw: Bool = true) {
        let finalJSArrStr = categories.aa_toJSArray()
        let jsFunctionStr = "aaGlobalChart.xAxis[0].setCategories(\(finalJSArrStr),\(redraw));"
        safeEvaluateJavaScriptString(jsFunctionStr)
    }
    
    /// Update the X axis Extremes
    /// Refer to https://api.highcharts.com/class-reference/Highcharts.Axis#setExtremes
    ///
    /// - Parameters:
    ///   - min: X axis minimum
    ///   - max: X axis maximum
    public func aa_updateXAxisExtremes(min: Int, max: Int) {
        let jsStr = "aaGlobalChart.xAxis[0].setExtremes(\(min), \(max))"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    /// Redraw chart view
    /// - Parameter animation: Have animation effect or not
    public func aa_redraw(animation: Bool = true) {
        let jsStr = "redrawWithAnimation('\(animation)')"
        safeEvaluateJavaScriptString(jsStr)
    }
    
    #if os(iOS)
    /// Set the chart view content be adaptive to screen rotation with default animation effect
    public func aa_adaptiveScreenRotation() {
        let aaAnimation = AAAnimation()
            .duration(800)
            .easing(.easeOutQuart)
        aa_adaptiveScreenRotationWithAnimation(aaAnimation)
    }

    /// Set the chart view content be adaptive to screen rotation with custom animation effect
    /// Refer to https://api.highcharts.com/highcharts#Chart.setSize
    ///
    /// - Parameter animation: The instance object of AAAnimation
    public func aa_adaptiveScreenRotationWithAnimation(_ animation: AAAnimation) {
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: nil) { [weak self] _ in
                //Delay execution by 0.01 seconds to prevent incorrect screen width and height obtained when the screen is rotated
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self?.aa_resizeChart(animation: animation)
                }
            }
    }
    
    public func aa_resizeChart(animation: AAAnimation) {
        let animationJsonStr = animation.toJSON()
        let jsFuncStr = "changeChartSize('\(frame.size.width)','\(frame.size.height)','\(animationJsonStr)')"
        safeEvaluateJavaScriptString(jsFuncStr)
    }
    #endif
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


// MARK: - JSONSerialization
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartView {
    
    func getJSONStringFromDictionary(dictionary: [String: Any]) -> String {
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            print("❌ Dictionary object is not valid JSON")
            return ""
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("❌ Error serializing dictionary to JSON: \(error.localizedDescription)")
        }
        return ""
    }
    
    func getJSONStringFromArray(array: [Any]) -> String {
        guard JSONSerialization.isValidJSONObject(array) else {
            print("❌ Array object is not valid JSON")
            return ""
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("❌ Error serializing array to JSON: \(error.localizedDescription)")
        }
        return ""
    }
    
    func getDictionaryFromJSONString(jsonString: String) -> [String: Any] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Failed to convert string to data")
            return [:]
        }
        
        do {
            if let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                return dict
            }
        } catch {
            print("❌ Error parsing JSON string to dictionary: \(error.localizedDescription)")
        }
        return [:]
    }
    
    func getArrayFromJSONString(jsonString: String) -> [Any] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Failed to convert string to data")
            return []
        }
        
        do {
            if let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [Any] {
                return array
            }
        } catch {
            print("❌ Error parsing JSON string to array: \(error.localizedDescription)")
        }
        return []
    }
}

