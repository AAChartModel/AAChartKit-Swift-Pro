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
