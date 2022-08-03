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
        
        let aaOptions = topRoundedCornersStackingColumnChart()
        aaChartView.aa_drawChartWithChartOptions(aaOptions)
    }
    
    private func configureChartView() {
        aaChartView = AAChartView()
        let chartViewWidth = view.frame.size.width
        let chartViewHeight = view.frame.size.height - 220
        aaChartView!.frame = CGRect(x: 0,
                                    y: 60,
                                    width: chartViewWidth,
                                    height: chartViewHeight)
        view.addSubview(aaChartView!)
        aaChartView!.isScrollEnabled = false//Disable chart content scrolling
    }
    
    private func configureChartViewCustomEventMessageHandler() {
        aaChartView!.configuration.userContentController.add(AALeakAvoider.init(delegate: self), name: kUserContentMessageNameChartClicked)
    }
    
    private func topRoundedCornersStackingColumnChart() -> AAOptions {
         func xrangeChart() -> AAOptions {
            AAOptions()
                .chart(AAChart()
                        .type(.xrange))
                .colors([
                    "#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9",
                    "rgb(255,143,179)","rgb(255,117,153)",
                    "#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1","#7cb5ec","#434348","#f7a35c",
                    "rgb(119,212,100)","rgb(93,186,74)","rgb(68,161,49)"
                ])
                .title(AATitle()
                        .text(""))
                .yAxis(AAYAxis()
                        .visible(true)
                        .title(AATitle()
                                .text(""))
                        .reversed(true)
                        .categories(["原型","开发","测试","上线"])
                        .gridLineWidth(0))
                .legend(AALegend()
                            .enabled(false))
                .plotOptions(AAPlotOptions()
                                .series(AASeries()
                                            .pointPadding(0)
                                            .groupPadding(0)))
                .series([
                    AASeriesElement()
                        .borderRadius(2)
                        .data(AAOptionsData.xrangeData)
                ])
        }
        
        let aaOptions = xrangeChart()
        
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

//    点击图表后, DOMRect 取值示例:
//    DOMRect = "{\"x\":383.5,\"y\":608.5,\"width\":9,\"height\":32,\"top\":608.5,\"right\":392.5,\"bottom\":640.5,\"left\":383.5}";
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
            print("✋🏻✋🏻✋🏻✋🏻✋🏻点击图表后, 获取的 SVG 元素的水平中心点的坐标为:\(frameX)")
            self.lineView.frame = CGRect(x: CGFloat(frameX), y: 0, width: 2, height: self.view.frame.size.height)
            
            print(
                """

                clicked point series element name: \(clickEventMessage["name"] ?? "")
                🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! Click Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
                ==========================================================================================
                ------------------------------------------------------------------------------------------
                user finger CLICKED!!!,get the custom click event message: {
                category = \(String(describing: clickEventMessage["category"]))
                index = \(String(describing: clickEventMessage["index"]))
                name = \(String(describing: clickEventMessage["name"]))
                x = \(String(describing: clickEventMessage["x"]))
                y = \(String(describing: clickEventMessage["y"]))
                DOMRect = \(String(describing: DOMRectDic))

                }
                +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
                
                """
            )

        }
    }
}


