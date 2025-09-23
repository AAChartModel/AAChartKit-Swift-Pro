//
//  AAOptionsCSV.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2022/8/6.
//

import Foundation

class AAOptionsCSV {
    
    public class var csvData: NSDictionary {
        getJsonCsvDataWithJsonFileName("bigHeatmapData")
    }
    
    private static func getJsonCsvDataWithJsonFileName(_ jsonFileName: String) -> NSDictionary {
        let path = Bundle.main.path(forResource: jsonFileName, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! NSDictionary
            
            return jsonArr 
            
        } catch let error as Error? {
            print("读取本地数据出现错误!",error ?? "WARNING!!!!")
        }
        return NSDictionary()
    }
    
}

