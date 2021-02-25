//
//  AAOptionsSeries.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2020/11/10.
//

import UIKit

class AAOptionsSeries {
    
    public class var packedbubbleSeries : [Any] {
        getJsonDataWithJsonFileName("packedbubbleSeries")
    }
    
    public class var streamgraphSeries : [Any] {
        getJsonDataWithJsonFileName("streamgraphSeries")
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
