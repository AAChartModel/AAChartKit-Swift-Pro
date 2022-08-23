//
//  CustomAnyEventCallback.swift
//  AAInfographicsDemo
//
//  Created by Admin on 2022/8/2.
//  Copyright © 2022 An An. All rights reserved.
//

import UIKit
import WebKit

let kUserContentMessageNameChartClicked = "click"
let kUserContentMessageNameChartDefaultSelected = "defaultSelected"


class CustomClickEventCallbackMessageVC: UIViewController {
    private var aaChartView: AAChartView!
    lazy var lineView: UIView = {
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = .red
        self.view.addSubview(lineView)
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureChartView()
        configureChartViewCustomEventMessageHandler()
        
        let aaOptions = xrangeChartWithCustomJSFunction()
        aaChartView.aa_drawChartWithChartOptions(aaOptions)
    }
    
    private func configureChartView() {
        aaChartView = AAChartView()
        let chartViewWidth = view.frame.size.width
        let chartViewHeight = view.frame.size.height
        aaChartView!.frame = CGRect(x: 0,
                                    y: 60,
                                    width: chartViewWidth,
                                    height: chartViewHeight)
        aaChartView!.delegate = self as AAChartViewDelegate
        view.addSubview(aaChartView!)
        aaChartView!.isScrollEnabled = false//Disable chart content scrolling
    }
    
    private func configureChartViewCustomEventMessageHandler() {
        aaChartView!.configuration.userContentController.add(AALeakAvoider.init(delegate: self), name: kUserContentMessageNameChartClicked)
        
        aaChartView!.configuration.userContentController.add(AALeakAvoider.init(delegate: self), name: kUserContentMessageNameChartDefaultSelected)
    }
    
    private func xrangeChartWithCustomJSFunction() -> AAOptions {
         func areasplineChart() -> AAOptions {
             let aaChartModel = AAChartModel()
                 .chartType(.areaspline)
                 .colorsTheme([
                     AAGradientColor.linearGradient(startColor: AARgb(128, 255, 165), endColor: AARgb(1  , 191, 236)),
                     AAGradientColor.linearGradient(startColor: AARgb(0  , 221, 255), endColor: AARgb(77 , 119, 255)),
                     AAGradientColor.linearGradient(startColor: AARgb(55 , 162, 255), endColor: AARgb(116, 21 , 219)),
                     AAGradientColor.linearGradient(startColor: AARgb(255, 0  , 135), endColor: AARgb(135, 0  , 157)),
                     AAGradientColor.linearGradient(startColor: AARgb(255, 191, 0  ), endColor: AARgb(224, 62 , 76 )),
                 ])
                 .xAxisLabelsStyle(AAStyle(color: AAColor.white))
                 .dataLabelsEnabled(false)
                 .stacking(.normal)
                 .tooltipValueSuffix("℃")
                 .markerSymbol(.circle)
                 .series([
                    AASeriesElement()
                        .name("Tokyo Hot")
                        .data([0.45, 0.43, 0.50, 0.55, 0.58, 0.62, 0.83, 0.39, 0.56, 0.67, 0.50, 0.34, 0.50, 0.67, 0.58, 0.29, 0.46, 0.23, 0.47, 0.46, 0.38, 0.56, 0.48, 0.36])
                    ,
                    AASeriesElement()
                        .name("Berlin Hot")
                        .data([0.38, 0.31, 0.32, 0.32, 0.64, 0.66, 0.86, 0.47, 0.52, 0.75, 0.52, 0.56, 0.54, 0.60, 0.46, 0.63, 0.54, 0.51, 0.58, 0.64, 0.60, 0.45, 0.36, 0.67])
                    ,
                    AASeriesElement()
                        .name("New York Hot")
                        .data([0.46, 0.32, 0.53, 0.58, 0.86, 0.68, 0.85, 0.73, 0.69, 0.71, 0.91, 0.74, 0.60, 0.50, 0.39, 0.67, 0.55, 0.49, 0.65, 0.45, 0.64, 0.47, 0.63, 0.64])
                    ,
                    AASeriesElement()
                        .name("London Hot")
                        .data([0.60, 0.51, 0.52, 0.53, 0.64, 0.84, 0.65, 0.68, 0.63, 0.47, 0.72, 0.60, 0.65, 0.74, 0.66, 0.65, 0.71, 0.59, 0.65, 0.77, 0.52, 0.53, 0.58, 0.53])
                    ,
                    ])
             
             return aaChartModel.aa_toAAOptions()
        }
        
        let aaOptions = areasplineChart()
        
//        获取用户点击位置的代码逻辑, 参考:
//        * https://www.highcharts.com/forum/viewtopic.php?t=11983
//        * https://developer.mozilla.org/zh-CN/docs/Web/API/Element/getBoundingClientRect
        
//        JSON.stringify(), 参考:
//        * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
        aaOptions.plotOptions?.series?
            .point(AAPoint()
                .events(AAPointEvents()
                    .click("""
             function() {
                let svgElement = aaGlobalChart.series[0].data[this.index].graphic.element;
                let rect = svgElement.getBoundingClientRect();
                let messageBody = {
                    "name": this.series.name,
                    "y": this.y,
                    "x": this.x,
                    "category": this.category,
                    "index": this.index,
                    "DOMRect": JSON.stringify(rect),
                };
                window.webkit.messageHandlers.\(kUserContentMessageNameChartClicked).postMessage(messageBody);
            }
""")))
        
        //默认选中的位置索引
        let defaultSelectedIndex = 5
                
        //https://api.highcharts.com/highcharts/chart.events.load
        //https://www.highcharts.com/forum/viewtopic.php?t=36508
        aaOptions.chart?.events(
            AAChartEvents()
                .load("""
        function() {
            let points = [],
                chart = this,
                series = chart.series,
                length = series.length;

            let defaultSelectedIndex = \(defaultSelectedIndex);

            for (let i = 0; i < length; i++) {
              let pointElement = series[i].data[defaultSelectedIndex];
              points.push(pointElement);
            }
            chart.tooltip.refresh(points);

            let selectedPointDataElement = chart.series[0].data[defaultSelectedIndex];
            let svgElement = selectedPointDataElement.graphic.element;
            let rect = svgElement.getBoundingClientRect();
            let messageBody = {
                "index": defaultSelectedIndex,
                "DOMRect": JSON.stringify(rect),
                "x": selectedPointDataElement.x,
                "x2": selectedPointDataElement.x2,
                "y": selectedPointDataElement.y,
            };
            window.webkit.messageHandlers.\(kUserContentMessageNameChartDefaultSelected).postMessage(messageBody);
          }
"""))

        return aaOptions
    }
    
    func convertJSValueToFloat(jsValue: Any?) -> Float {
        var floatValue: Float = 0
        if jsValue is String {
            floatValue = Float(jsValue as! String)!
        } else if jsValue is Int {
            floatValue = Float(jsValue as! Int)
        } else if jsValue is Float {
            floatValue = (jsValue as! Float)
        } else if jsValue is Double {
            floatValue = Float(jsValue as! Double)
        }
        return floatValue
    }
    
    private func getEventMessageModel(DOMRectDic: [String: Any]) -> DOMRectModel {
        let DOMRectModel = DOMRectModel()
        DOMRectModel.x = convertJSValueToFloat(jsValue: DOMRectDic["x"])
        DOMRectModel.y = convertJSValueToFloat(jsValue: DOMRectDic["y"])
        DOMRectModel.width = convertJSValueToFloat(jsValue: DOMRectDic["width"])
        DOMRectModel.height = convertJSValueToFloat(jsValue: DOMRectDic["height"])
        DOMRectModel.top = convertJSValueToFloat(jsValue: DOMRectDic["top"])
        DOMRectModel.right = convertJSValueToFloat(jsValue: DOMRectDic["right"])
        DOMRectModel.bottom = convertJSValueToFloat(jsValue: DOMRectDic["bottom"])
        DOMRectModel.left = convertJSValueToFloat(jsValue: DOMRectDic["left"])
        return DOMRectModel
    }
}

// MARK: 字符串转字典
func stringValueDic(_ str: String) -> [String : Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let dict = try? JSONSerialization.jsonObject(with: data!,
                    options: .mutableContainers) as? [String : Any] {
        return dict
    }

    return nil
}

func dicStringToPrettyString(dic: Any) -> String {
    return String(data: try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted), encoding: .utf8)!
}

class DOMRectModel {
    public var x: Float?
    public var y: Float?
    public var width: Float?
    public var height: Float?
    public var top: Float?
    public var right: Float?
    public var bottom: Float?
    public var left: Float?
}

extension CustomClickEventCallbackMessageVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == kUserContentMessageNameChartClicked {
            let clickEventMessage = message.body as! [String: Any]
            let DOMRectDic = stringValueDic(clickEventMessage["DOMRect"] as! String)!
            let DOMRectModel = getEventMessageModel(DOMRectDic: DOMRectDic )
            
            let frameX = DOMRectModel.x! + (DOMRectModel.width! / 2)
            print("点击图表后, 获取的 SVG 元素的水平中心点的坐标为:\(frameX)")
            self.lineView.frame = CGRect(x: CGFloat(frameX), y: 0, width: 2, height: self.view.frame.size.height)
            self.lineView.backgroundColor = .red
            
            print("""
                clicked point series element name: \(clickEventMessage["name"] ?? "")
                🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! Click Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
                ——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧
                \(dicStringToPrettyString(dic: clickEventMessage))
                ——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧
                """
            )
            
        } else if message.name == kUserContentMessageNameChartDefaultSelected {
            let defaultSelectedEventMessage = message.body as! [String: Any]
            let DOMRectDic = stringValueDic(defaultSelectedEventMessage["DOMRect"] as! String)!
            let DOMRectModel = getEventMessageModel(DOMRectDic: DOMRectDic )
            
            let frameX = DOMRectModel.x! + (DOMRectModel.width! / 2)
            print("默认选中图表后, 获取的 SVG 元素的水平中心点的坐标为:\(frameX)")
            self.lineView.frame = CGRect(x: CGFloat(frameX), y: 0, width: 3, height: self.view.frame.size.height)
            self.lineView.backgroundColor = .blue
            
            print("""
                  🎉🎉🎉 !!!Got the custom event message!!! 🎉🎉🎉
                  ———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧
                  \(dicStringToPrettyString(dic: defaultSelectedEventMessage))
                  ———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧———‧
                  """)
        }
    }
}

extension CustomClickEventCallbackMessageVC: AAChartViewDelegate {
    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        print(
            """

            moved over point series element name: \(moveOverEventMessage.name ?? "")
            ✋🏻✋🏻✋🏻✋🏻✋🏻WARNING!!!!!!!!!!!!!! Move Over Event Message !!!!!!!!!!!!!! WARNING✋🏻✋🏻✋🏻✋🏻✋🏻
            ==========================================================================================
            ------------------------------------------------------------------------------------------
            user finger MOVED OVER!!!,get the move over event message: {
            category = \(String(describing: moveOverEventMessage.category))
            index = \(String(describing: moveOverEventMessage.index))
            name = \(String(describing: moveOverEventMessage.name))
            offset = \(String(describing: moveOverEventMessage.offset))
            x = \(String(describing: moveOverEventMessage.x))
            y = \(String(describing: moveOverEventMessage.y))
            }
            +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            
            """
        )
    }
}



