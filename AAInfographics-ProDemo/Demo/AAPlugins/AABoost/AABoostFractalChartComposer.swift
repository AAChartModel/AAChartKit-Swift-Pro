//
//  AABoostFractalChartComposer.swift
//  AAChartKit-ProDemo
//
//  Created by AnAn on 2025/4/9.
//  Copyright © 2025 An An. All rights reserved.
//

import Foundation

class AABoostFractalChartComposer {

    /**
     
     function generateSierpinskiData() {
         const data = [];
         const canvasSize = 800; // 匹配容器尺寸

         // --- Carpet Parameters ---
         const maxDepth = 6; // 控制递归深度和细节 (6-7 通常足够)
         // const pointDensity = 1; // 1: 中心点, 2: 角点, >2: 更多点填充
         // --- End Carpet Parameters ---

         // --- Vibrant Color Function (保持不变或微调) ---
         function getColor(depth, maxDepth, x, y, size) {
             // 使用深度 t (0 到 1) 来驱动颜色变化
             const t = depth / maxDepth;

             // 霓虹/宇宙风格
             const freq1 = 0.25, phase1 = 1.5; // 调整频率相位获得不同效果
             const freq2 = 0.30, phase2 = 2.5;
             const freq3 = 0.35, phase3 = 0.5;

             // 可以加入位置影响，例如：
             const posFactor = (x + y) / (2 * canvasSize) * 0.2; // 轻微位置影响

             let r = Math.sin(freq1 * depth + phase1 + posFactor) * 127 + 128;
             let g = Math.sin(freq2 * depth + phase2 + posFactor) * 127 + 128;
             let b = Math.sin(freq3 * depth + phase3 + posFactor) * 127 + 128;

             // 亮度增强 (可以基于深度或位置)
             const brightnessBoost = Math.pow(t, 0.6);
             r = r * (0.7 + brightnessBoost * 0.8);
             g = g * (0.7 + brightnessBoost * 0.8);
             b = b * (0.7 + brightnessBoost * 0.8);

             r = Math.max(0, Math.min(255, Math.floor(r)));
             g = Math.max(0, Math.min(255, Math.floor(g)));
             b = Math.max(0, Math.min(255, Math.floor(b)));

             return `rgb(${r}, ${g}, ${b})`;
         }
         // --- End Color Function ---

         function generateCarpet(x, y, size, depth) {
             // Base Case: 当达到最大深度时，绘制当前方块区域的点
             if (depth >= maxDepth) {
                 // 绘制代表这个小方块的点 (可以增加点数提高密度)
                 const color = getColor(depth, maxDepth, x, y, size);
                 // 绘制中心点
                 data.push({ x: x + size / 2, y: y + size / 2, color: color });

                  // 可选：增加角点提高密度
                  // data.push({ x: x, y: y, color: color });
                  // data.push({ x: x + size, y: y, color: color });
                  // data.push({ x: x, y: y + size, color: color });
                  // data.push({ x: x + size, y: y + size, color: color });

                  // 可选：随机填充更多点 (性能消耗更大)
                  
                  // const numPoints = 5; // 每个最小方块填充的点数
                  // for (let i = 0; i < numPoints; i++) {
                  //     data.push({
                  //         x: x + Math.random() * size,
                  //         y: y + Math.random() * size,
                  //         color: color
                  //     });
                  // }
                  
                 return;
             }

             // Recursive Step: 分成 3x3 网格，对 8 个非中心方块进行递归
             const newSize = size / 3;
             for (let i = 0; i < 3; i++) { // 列 (x)
                 for (let j = 0; j < 3; j++) { // 行 (y)
                     // 跳过中心方块 (i=1, j=1)
                     if (i === 1 && j === 1) {
                         continue;
                     }
                     // 计算新方块的左下角坐标 (注意 Highcharts Y 轴向上)
                     const newX = x + i * newSize;
                     const newY = y + j * newSize; // 在 Highcharts 中，Y=0 在底部，所以这样计算是正确的
                     generateCarpet(newX, newY, newSize, depth + 1);
                 }
             }
         }

         // 初始调用，覆盖整个画布
         // 注意：Highcharts Y轴从下到上，所以 (0,0) 是左下角
         generateCarpet(0, 0, canvasSize, 0);

         console.log("Generated points:", data.length);
         return data;
     }

     Highcharts.chart('container', {
         chart: {
             type: 'scatter',
             zoomType: 'xy',
             boost: {
                 useGPUTranslations: true,
                 usePreallocated: true,
                 seriesThreshold: 1
             },
             backgroundColor: 'transparent', // 透明背景
             renderTo: 'container'
         },
         title: {
             text: 'Colorful Sierpinski Carpet', // 更新标题
             style: {
                 color: '#e0f0ff',
                 fontSize: '24px',
                 textShadow: '0 0 5px #ffffff'
              }
         },
         // 设置坐标轴范围以匹配画布大小
         xAxis: { min: 0, max: 800, visible: false, startOnTick: false, endOnTick: false },
         yAxis: { min: 0, max: 800, visible: false, startOnTick: false, endOnTick: false },
         legend: { enabled: false },
         plotOptions: {
             scatter: {
                 marker: {
                     radius: 1, // 根据 maxDepth 和点密度调整
                     symbol: 'square' // 方形标记更符合地毯主题
                 },
                 tooltip: { enabled: false },
                 boostThreshold: 1,
                 states: {
                     hover: { enabled: false },
                     inactive: { enabled: false }
                 }
             }
         },
         series: [{
             name: 'Carpet',
             data: generateSierpinskiData(),
             // animation: false // 可选：禁用动画
         }],
         credits: { enabled: false }
     });

     */
    
    class func generateSierpinskiData() -> [Any] {
        var data = [Any]()
        let canvasSize: CGFloat = 800 // 匹配容器尺寸
        
        // --- Carpet Parameters ---
        let maxDepth = 6 // 控制递归深度和细节 (6-7 通常足够)
        // const pointDensity = 1; // 1: 中心点, 2: 角点, >2: 更多点填充
        // --- End Carpet Parameters ---
        
        // --- 用于递归生成地毯的内部方法 ---
        func getColor(depth: Int, maxDepth: Int, x: CGFloat, y: CGFloat, size: CGFloat) -> String {
            // 使用深度 t (0 到 1) 来驱动颜色变化
            let t = CGFloat(depth) / CGFloat(maxDepth)
            
            // 霓虹/宇宙风格
            let freq1: CGFloat = 0.25, phase1: CGFloat = 1.5 // 调整频率相位获得不同效果
            let freq2: CGFloat = 0.30, phase2: CGFloat = 2.5
            let freq3: CGFloat = 0.35, phase3: CGFloat = 0.5
            
            // 可以加入位置影响，例如：
            let posFactor = (x + y) / (2 * canvasSize) * 0.2 // 轻微位置影响
            
            var r = sin(freq1 * CGFloat(depth) + phase1 + posFactor) * 127 + 128
            var g = sin(freq2 * CGFloat(depth) + phase2 + posFactor) * 127 + 128
            var b = sin(freq3 * CGFloat(depth) + phase3 + posFactor) * 127 + 128
            
            // 亮度增强 (可以基于深度或位置)
            let brightnessBoost = pow(t, 0.6)
            r = r * (0.7 + brightnessBoost * 0.8)
            g = g * (0.7 + brightnessBoost * 0.8)
            b = b * (0.7 + brightnessBoost * 0.8)
            
            r = max(0, min(255, floor(r)))
            g = max(0, min(255, floor(g)))
            b = max(0, min(255, floor(b)))
            
            return "rgb(\(Int(r)), \(Int(g)), \(Int(b)))"
        }
        
        func generateCarpet(x: CGFloat, y: CGFloat, size: CGFloat, depth: Int) {
            // Base Case: 当达到最大深度时，绘制当前方块区域的点
            if depth >= maxDepth {
                // 绘制代表这个小方块的点 (可以增加点数提高密度)
                let color = getColor(depth: depth, maxDepth: maxDepth, x: x, y: y, size: size)
                // 绘制中心点
                data.append([
                    "x": x + size / 2,
                    "y": y + size / 2,
                    "color": color
                ])
                
                // 可选：增加角点提高密度
                // data.append(["x": x, "y": y, "color": color])
                // data.append(["x": x + size, "y": y, "color": color])
                // data.append(["x": x, "y": y + size, "color": color])
                // data.append(["x": x + size, "y": y + size, "color": color])
                
                // 可选：随机填充更多点 (性能消耗更大)
                /*
                let numPoints = 5 // 每个最小方块填充的点数
                for _ in 0..<numPoints {
                    data.append([
                        "x": x + CGFloat.random(in: 0...1) * size,
                        "y": y + CGFloat.random(in: 0...1) * size,
                        "color": color
                    ])
                }
                */
                
                return
            }
            
            // Recursive Step: 分成 3x3 网格，对 8 个非中心方块进行递归
            let newSize = size / 3
            for i in 0..<3 { // 列 (x)
                for j in 0..<3 { // 行 (y)
                    // 跳过中心方块 (i=1, j=1)
                    if i == 1 && j == 1 {
                        continue
                    }
                    // 计算新方块的左下角坐标 (注意 Highcharts Y 轴向上)
                    let newX = x + CGFloat(i) * newSize
                    let newY = y + CGFloat(j) * newSize // 在 Highcharts 中，Y=0 在底部，所以这样计算是正确的
                    generateCarpet(x: newX, y: newY, size: newSize, depth: depth + 1)
                }
            }
        }
        
        // 初始调用，覆盖整个画布
        // 注意：Highcharts Y轴从下到上，所以 (0,0) 是左下角
        generateCarpet(x: 0, y: 0, size: canvasSize, depth: 0)
        
        print("Generated points: \(data.count)")
        return data
    }
    
    class func boostFractalChart() -> AAOptions {
        // 配置 AAChartKit 图表选项
        let chart = AAChart()
            .type(.scatter)
//            .zoomType(.xy)
            .backgroundColor("transparent")
//            .boost(AABoost()
//                .useGPUTranslations(true)
//                .usePreallocated(true)
//                .seriesThreshold(1))
        
        let boost = AABoost()
            .useGPUTranslations(true)
            .usePreallocated(true)
            .seriesThreshold(1)
        
        let title = AATitle()
            .text("Colorful Sierpinski Carpet")
            .style(AAStyle()
                .color("#e0f0ff")
//                .fontSize("24px")
                .textOutline("0 0 5px #ffffff"))
        
        let xAxis = AAXAxis()
            .min(0)
            .max(800)
            .visible(false)
            .startOnTick(false)
            .endOnTick(false)
        
        let yAxis = AAYAxis()
            .min(0)
            .max(800)
            .visible(false)
            .startOnTick(false)
            .endOnTick(false)
        
        let seriesElement = AASeriesElement()
            .name("Carpet")
            .data(generateSierpinskiData())
            .marker(AAMarker()
                .radius(1)
//                .symbol(.square)
            )
        
        let options = AAOptions()
            .chart(chart)
            .boost(boost)
            .title(title)
            .xAxis(xAxis)
            .yAxis(yAxis)
            .series([seriesElement])
            .credits(AACredits().enabled(false))
        
        return options
    }
}
