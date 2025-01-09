//
//  CustomAnyEventCallback.swift
//  AAInfographicsDemo
//
//  Created by Admin on 2022/8/2.
//  Copyright © 2022 An An. All rights reserved.
//

import UIKit
import WebKit

class CustomClickEventCallbackMessageVC2: UIViewController {
    let kUserContentMessageNameChartClicked = "click"
    let kUserContentMessageNameChartMoveOver = "moveOver"
    
    public var aaChartView: AAChartView!
    lazy var lineView: UIView = {
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = .red
        self.aaChartView.addSubview(lineView)
        return lineView
    }()
    
    //第二个 lineView
    lazy var lineView2: UIView = {
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = .green
        self.aaChartView.addSubview(lineView)
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
        view.addSubview(aaChartView!)
        aaChartView!.isScrollEnabled = false//Disable chart content scrolling
        //禁止自动调整滚动视图的内边距
        aaChartView!.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configureChartViewCustomEventMessageHandler() {
        let scriptMessageHandler = AALeakAvoider.init(delegate: self)
        let chartConfiguration = aaChartView!.configuration
        
        chartConfiguration.userContentController.add(scriptMessageHandler, name: kUserContentMessageNameChartClicked)
        chartConfiguration.userContentController.add(scriptMessageHandler, name: kUserContentMessageNameChartMoveOver)
    }
    
    private func xrangeChartWithCustomJSFunction() -> AAOptions {
         func areasplineChart() -> AAOptions {
             let aaChartModel = AAChartModel()
                 .chartType(.column)
                 .colorsTheme([
                    AAColor.lightGray,
                    AAColor.black,
                 ])
                 .categories([
                    "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
                    "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
                ])
                 .xAxisLabelsStyle(AAStyle(color: AAColor.black, fontSize: 16))
                 .dataLabelsEnabled(false)
                 .stacking(.normal)
                 .tooltipValueSuffix("℃")
                 .markerSymbol(.circle)
                 .borderRadius(10)
                 .series([
                    AASeriesElement()
                        .name("Tokyo Hot")
                        .data([0.45, 0.43, 0.50, 0.55, 0.58, 0.62, 0.83, 0.39, 0.56, 0.67, 0.50, 0.34, 0.50, 0.67, 0.58, 0.29, 0.46, 0.23, 0.47, 0.46, 0.38, 0.56, 0.48, 0.36])
                    ,
                    AASeriesElement()
                        .name("Berlin Hot")
                        .data([0.38, 0.31, 0.32, 0.32, 0.64, 0.66, 0.86, 0.47, 0.52, 0.75, 0.52, 0.56, 0.54, 0.60, 0.46, 0.63, 0.54, 0.51, 0.58, 0.64, 0.60, 0.45, 0.36, 0.67])
                    ,
                    ])
             
             return aaChartModel.aa_toAAOptions()
        }
        
        func configureClickOrMoveOverEventJSEvent(userContentMessageName: String) -> String {
return """
  function() {
      let chart = this.series.chart;
      let messageBodies = [];

      chart.series.forEach(series => {
          let dataPoint = series.data[this.index];
          
          if (dataPoint && dataPoint.graphic && dataPoint.graphic.element) {
              let svgElement = dataPoint.graphic.element;
              let rect = svgElement.getBoundingClientRect();
              
              let messageBody = {
                  "name": series.name,
                  "y": dataPoint.y,
                  "x": dataPoint.x,
                  "category": dataPoint.category,
                  "index": this.index,
                  "DOMRect": JSON.stringify(rect),
              };
              
              messageBodies.push(messageBody);
          }
      });

      window.webkit.messageHandlers.\(userContentMessageName).postMessage(messageBodies);
  }
"""
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
                    .click(configureClickOrMoveOverEventJSEvent(userContentMessageName: kUserContentMessageNameChartClicked))
                    .mouseOver(configureClickOrMoveOverEventJSEvent(userContentMessageName: kUserContentMessageNameChartMoveOver))
                ))

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


extension CustomClickEventCallbackMessageVC2: WKScriptMessageHandler {
    fileprivate func extractedFunc(_ clickEventMessageArr: [[String : Any]], domIndex: Int, eventName: String) {
        let userEventMessage = clickEventMessageArr[domIndex]
        let DOMRectDic = stringValueDic(userEventMessage["DOMRect"] as! String)!
        let DOMRectModel = getEventMessageModel(DOMRectDic: DOMRectDic )
       
        let frameWidth = DOMRectModel.width! / 2
        let frameHeight = DOMRectModel.height!
        
        let frameX = DOMRectModel.x! + (frameWidth / 2)
        let frameY = DOMRectModel.y!

        print("点击图表后, 获取的 SVG 元素的水平中心点的坐标为:\(frameX)")
        print("点击图表后, 获取的 SVG 元素的垂直中心点的坐标为:\(frameY)")
        
        if domIndex == 0 {
            self.lineView.frame = CGRect(x: CGFloat(frameX), y: CGFloat(frameY), width: CGFloat(frameWidth), height: CGFloat(frameHeight))
            self.lineView.backgroundColor = .red
        } else {
            self.lineView2.frame = CGRect(x: CGFloat(frameX), y: CGFloat(frameY), width: CGFloat(frameWidth), height: CGFloat(frameHeight))
            self.lineView2.backgroundColor = .green 
        }
   
        print("""
                \(eventName) point series element name: \(userEventMessage["name"] ?? "")
                🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! \(eventName) Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
                ——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧
                \(dicStringToPrettyString(dic: userEventMessage))
                ——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧——‧
                """
        )

        //打印 lineView 的 frame
        print("lineView.frame: \(self.lineView.frame)")
        print("lineView2.frame: \(self.lineView2.frame)")
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let clickEventMessageArr = message.body as! [[String: Any]]
        for i in 0..<clickEventMessageArr.count {
            extractedFunc(clickEventMessageArr, domIndex: i, eventName: message.name)
        }
    }
}




