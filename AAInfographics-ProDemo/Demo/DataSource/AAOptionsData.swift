//
//  AAOptionsData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

class AAOptionsData {
    
    public class var variablepieData: [Any] {
        getJsonDataWithJsonFileName("variablepieData")
    }
    
    public class var variwideData : [Any] {
        getJsonDataWithJsonFileName("variwideData")
    }
    
    public class var heatmapData : [Any] {
        getJsonDataWithJsonFileName("heatmapData")
    }
    
    public class var columnpyramidData : [Any] {
        getJsonDataWithJsonFileName("columnpyramidData")
    }
    
    public class var treemapWithColorAxisData : [Any] {
        getJsonDataWithJsonFileName("treemapWithColorAxisData")
    }
    
    public class var drilldownTreemapData : [Any] {
        getJsonDataWithJsonFileName("drilldownTreemapData")
    }
    
    
    
    
    public class var sankeyData : [Any] {
        getJsonDataWithJsonFileName("sankeyData")
    }
    
    public class var dependencywheelData : [Any] {
        getJsonDataWithJsonFileName("dependencywheelData")
    }
    
    public class var sunburstData : [Any] {
        getJsonDataWithJsonFileName("sunburstData")
    }
    
    public class var dumbbellData : [Any] {
        getJsonDataWithJsonFileName("dumbbellData")
    }
    
    public class var vennData : [Any] {
        getJsonDataWithJsonFileName("vennData")
    }
    
    public class var lollipopData : [Any] {
        getJsonDataWithJsonFileName("lollipopData")
    }
    
    public class var tilemapData : [Any] {
        getJsonDataWithJsonFileName("tilemapData")
    }
    
    public class var treemapWithLevelsData : [Any] {
        getJsonDataWithJsonFileName("treemapWithLevelsData")
    }
    
    public class var bellcurveData : [Any] {
        getJsonDataWithJsonFileName("bellcurveData")
    }
    
    public class var timelineData : [Any] {
        getJsonDataWithJsonFileName("timelineData")
    }
    
    public class var timeline2Data : [Any] {
        getJsonDataWithJsonFileName("timeline2Data")
    }
    
    public class var itemData : [Any] {
        getJsonDataWithJsonFileName("itemData")
    }
    
    public class var windbarbData : [Any] {
        getJsonDataWithJsonFileName("windbarbData")
    }
    
    public class var networkgraphData : [Any] {
        getJsonDataWithJsonFileName("networkgraphData")
    }
    
    public class var wordcloudData : [Any] {
        getJsonDataWithJsonFileName("wordcloudData")
    }
    
    public class var eulerData : [Any] {
        getJsonDataWithJsonFileName("eulerData")
    }

    
    public class var organizationData : [Any] {
        getJsonDataWithJsonFileName("organizationData")
    }
    
    public class var organizationNodesData : [Any] {
        getJsonDataWithJsonFileName("organizationNodesData")
    }
    
    
    public class var arcdiagram1Data : [Any] {
        getJsonDataWithJsonFileName("arcdiagram1Data")
    }
    
    public class var arcdiagram2Data : [Any] {
        getJsonDataWithJsonFileName("arcdiagram2Data")
    }
    
    public class var arcdiagram3Data : [Any] {
        getJsonDataWithJsonFileName("arcdiagram3Data")
    }
    
    public class var flameData : [Any] {
        getJsonDataWithJsonFileName("flameData")
    }
    
    public class var sunburst2Data : [Any] {
        getJsonDataWithJsonFileName("sunburst2Data")
    }
    
    public class var marathonData : [Any] {
        getJsonDataWithJsonFileName("marathonData")
    }
    
    public class var xrangeData: [Any] {
        func getSingleGroupCategoryDataElementArrayWithY(_ y: Int) -> [Any] {
            var dataArr = [Any]()
            
            var x = 0
            var x2 = x + Int(arc4random()) % 10
            for _ in 0 ..< 50 {
                var dataElementDic = [String:Any]()
                dataElementDic["x"] = x
                dataElementDic["x2"] = x2
                dataElementDic["y"] = y
                dataArr.append(dataElementDic)
                x = x2 + Int(arc4random()) % 1000
                x2 = x + Int(arc4random()) % 2000
            }
            return dataArr
        }
        
        var dataArr = [Any]()
        for y in 0 ..< 20 {
            let data = getSingleGroupCategoryDataElementArrayWithY(y)
            for dataElement in data {
                dataArr.append(dataElement)
            }
        }
        return dataArr
    }
    
    public class var xrange2Data: [Any] {
        func getSingleGroupCategoryDataElementArrayWithY(_ y: Int) -> [Any] {
            var dataArr = [Any]()
            
            var x = 0
            var x2 = x + Int(arc4random()) % 10
            for _ in 0 ..< 50 {
                var dataElementDic = [String:Any]()
                dataElementDic["x"] = x
                dataElementDic["x2"] = x2
                dataElementDic["y"] = y
                
                //添加随机生成的颜色, 用于测试
                let R = arc4random_uniform(256)
                let G = arc4random_uniform(256)
                let B = arc4random_uniform(256)
                let rgbaColorStr = AARgba(Int(R), Int(G), Int(B), 0.9)
                dataElementDic["color"] = rgbaColorStr
                
                dataArr.append(dataElementDic)
                x = x2 + Int(arc4random()) % 1000
                x2 = x + Int(arc4random()) % 2000
            }
            return dataArr
        }
        
        var dataArr = [Any]()
        for y in 0 ..< 20 {
            let data = getSingleGroupCategoryDataElementArrayWithY(y)
            for dataElement in data {
                dataArr.append(dataElement)
            }
        }
        return dataArr
    }
    
    public class func randomSleepData(count: Int) -> [[String]] {
        var dataset: [[String]] = []
        let startTime = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 7, hour: 22, minute: 0))!
        let endTime = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 8, hour: 6, minute: 0))!
        let totalDuration = endTime.timeIntervalSince(startTime)
        
        var currentTime = startTime
        let avgDuration = totalDuration / Double(count)
        let minDuration = max(60.0, avgDuration * 0.3) // 最少1分钟
        let maxDuration = min(3600.0, avgDuration * 2) // 最多1小时
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        var lastStage: String?
        
        for i in 0..<count {
            var stage: String
            
            // 根据睡眠阶段特点选择stage
            let progress = currentTime.timeIntervalSince(startTime) / totalDuration
            
            repeat {
                if progress < 0.2 {
                    stage = Double.random(in: 0...1) < 0.6 ? "Core" : (Double.random(in: 0...1) < 0.7 ? "REM" : "Awake")
                } else if progress < 0.4 {
                    stage = Double.random(in: 0...1) < 0.4 ? "Deep" : (Double.random(in: 0...1) < 0.8 ? "Core" : "REM")
                } else if progress < 0.7 {
                    let rand = Double.random(in: 0...1)
                    if rand < 0.2 { stage = "Deep" }
                    else if rand < 0.6 { stage = "Core" }
                    else if rand < 0.85 { stage = "REM" }
                    else { stage = "Awake" }
                } else {
                    stage = Double.random(in: 0...1) < 0.4 ? "REM" : (Double.random(in: 0...1) < 0.7 ? "Core" : "Awake")
                }
            } while stage == lastStage
            lastStage = stage
            
            var duration: TimeInterval
            if i == count - 1 {
                duration = endTime.timeIntervalSince(currentTime)
            } else {
                let remainingTime = endTime.timeIntervalSince(currentTime)
                let remainingSegments = Double(count - i)
                let maxAllowedDuration = remainingTime - (remainingSegments - 1) * minDuration
                let effectiveMaxDuration = min(maxDuration, maxAllowedDuration)
                duration = Double.random(in: minDuration...effectiveMaxDuration)
            }
            
            duration = max(minDuration, min(duration, endTime.timeIntervalSince(currentTime)))
            
            let segmentEnd = currentTime.addingTimeInterval(duration)
            let startStr = formatter.string(from: currentTime)
            let endStr = formatter.string(from: segmentEnd)
            
            dataset.append([startStr, endStr, stage])
            
            currentTime = segmentEnd
            if currentTime >= endTime { break }
        }
        
        return dataset
    }
    
    public class var vectorData : [Any] {
        getJsonDataWithJsonFileName("vectorData")
    }


    public class var volinPlotElement1Data : [Any] {
        getJsonDataWithJsonFileName("volinPlotElement1Data")
    }

    public class var volinPlotElement2Data : [Any] {
        getJsonDataWithJsonFileName("volinPlotElement2Data")
    }

    public class var simpleDependencyWheelData : [Any] {
        getJsonDataWithJsonFileName("simpleDependencyWheelData")
    }

    public class var simpleTilemapData : [Any] {
        getJsonDataWithJsonFileName("simpleTilemapData")
    }

    public class var tilemapForAfricaData : [Any] {
        getJsonDataWithJsonFileName("tilemapForAfricaData")
    }
    
    //https://www.jianshu.com/p/a4b2bd5deca6
    private static func getJsonDataWithJsonFileName(_ jsonFileName: String) -> [Any] {
        let path = Bundle.main.path(forResource: jsonFileName, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! NSArray
            
            return jsonArr as! [Any]
            
        } catch let error as Error? {
            print("读取本地数据出现错误!",error ?? "WARNING!!!!")
        }
        return [Any]()
    }
    
}
