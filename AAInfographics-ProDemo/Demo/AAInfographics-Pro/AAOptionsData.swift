//
//  AAOptionsData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

class AAOptionsData {
    
    public class var variablepieData: [Any] {
        return getJsonDataWithJsonFileName("variablepieData")
    }

    public class var variwideData : [Any] {
        return getJsonDataWithJsonFileName("variwideData")
    }

    public class var heatmapData : [Any] {
        return getJsonDataWithJsonFileName("heatmapData")
    }

    public class var packedbubbleData : [Any] {
        return getJsonDataWithJsonFileName("packedbubbleData")
    }

    public class var packedbubbleSplitData : [Any] {
        return getJsonDataWithJsonFileName("packedbubbleSplitData")
    }

    public class var columnpyramidData : [Any] {
        return getJsonDataWithJsonFileName("columnpyramidData")
    }

    public class var treemapWithColorAxisData : [Any] {
        return getJsonDataWithJsonFileName("treemapWithColorAxisData")
    }

    public class var drilldownTreemapData : [Any] {
        return getJsonDataWithJsonFileName("drilldownTreemapData")
    }




    public class var sankeyData : [Any] {
        return getJsonDataWithJsonFileName("sankeyData")
    }

    public class var dependencywheelData : [Any] {
        return getJsonDataWithJsonFileName("dependencywheelData")
    }

    public class var sunburstData : [Any] {
        return getJsonDataWithJsonFileName("sunburstData")
    }

    public class var dumbbellData : [Any] {
        return getJsonDataWithJsonFileName("dumbbellData")
    }

    public class var vennData : [Any] {
        return getJsonDataWithJsonFileName("vennData")
    }

    public class var lollipopData : [Any] {
        return getJsonDataWithJsonFileName("lollipopData")
    }

    public class var tilemapData : [Any] {
        return getJsonDataWithJsonFileName("tilemapData")
    }

    public class var treemapWithLevelsData : [Any] {
        return getJsonDataWithJsonFileName("treemapWithLevelsData")
    }

    public class var bellcurveData : [Any] {
        return getJsonDataWithJsonFileName("bellcurveData")
    }

    public class var timelineData : [Any] {
        return getJsonDataWithJsonFileName("timelineData")
    }

    public class var itemData : [Any] {
        return getJsonDataWithJsonFileName("itemData")
    }

    public class var windbarbData : [Any] {
        return getJsonDataWithJsonFileName("windbarbData")
    }

    public class var networkgraphData : [Any] {
        return getJsonDataWithJsonFileName("networkgraphData")
    }

    public class var wordcloudData : [Any] {
        return getJsonDataWithJsonFileName("wordcloudData")
    }

    public class var eulerData : [Any] {
        return getJsonDataWithJsonFileName("eulerData")
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
        return getJsonDataWithJsonFileName("vectorData")
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
