//
//  AAFractalChartData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/9.
//

import UIKit

class AAFractalChartData: NSObject {
    /**
     function generateMandelbrotData() {
         const width = 800;
         const height = 800;
         const maxIterations = 100;
         const data = [];
         
         // 更鲜明的颜色映射
         function getColor(iterations) {
             if (iterations === maxIterations) {
                 return '#000000'; // 集合内的点保持黑色
             }
             // 根据迭代次数生成 RGB 颜色
             const r = Math.sin(iterations * 0.1) * 127 + 128;
             const g = Math.sin(iterations * 0.13 + 2) * 127 + 128;
             const b = Math.sin(iterations * 0.15 + 4) * 127 + 128;
             return `rgb(${Math.floor(r)},${Math.floor(g)},${Math.floor(b)})`;
         }

         for (let x = 0; x < width; x++) {
             for (let y = 0; y < height; y++) {
                 const real = (x - width/2) * 4.0/width;
                 const imag = (y - height/2) * 4.0/height;
                 
                 let zReal = real;
                 let zImag = imag;
                 let iterations = 0;

                 while (iterations < maxIterations &&
                        zReal * zReal + zImag * zImag < 4) {
                     const tempReal = zReal * zReal - zImag * zImag + real;
                     zImag = 2 * zReal * zImag + imag;
                     zReal = tempReal;
                     iterations++;
                 }

                 data.push({
                     x: x,
                     y: y,
                     color: getColor(iterations)
                 });
             }
         }

         return data;
     }
     */
    static func generateMandelbrotData() -> [[String: Any]] {
        let width = 800
        let height = 800
        let maxIterations = 100
        var data: [[String: Any]] = []
        
        // 更鲜明的颜色映射
        func getColor(iterations: Int) -> String {
            if iterations == maxIterations {
                return "#000000" // 集合内的点保持黑色
            }
            // 根据迭代次数生成 RGB 颜色
            let r = sin(Double(iterations) * 0.1) * 127 + 128
            let g = sin(Double(iterations) * 0.13 + 2) * 127 + 128
            let b = sin(Double(iterations) * 0.15 + 4) * 127 + 128
            return "rgb(\(Int(r)),\(Int(g)),\(Int(b)))"
        }
        
        for x in 0..<width {
            for y in 0..<height {
                let real = Double(x - width/2) * 4.0/Double(width)
                let imag = Double(y - height/2) * 4.0/Double(height)
                
                var zReal = real
                var zImag = imag
                var iterations = 0
                
                while iterations < maxIterations &&
                        zReal * zReal + zImag * zImag < 4 {
                    let tempReal = zReal * zReal - zImag * zImag + real
                    zImag = 2 * zReal * zImag + imag
                    zReal = tempReal
                    iterations += 1
                }
                
                data.append([
                    "x": x,
                    "y": y,
                    "color": getColor(iterations: iterations)
                ])
            }
        }
        print("Generated points: \(data.count)") // Log number of points for performance check

        return data
    }
    
    /**
     function generateFractalTreeData() {
         const data = [];
         const canvasWidth = 800;
         const canvasHeight = 800;

         // --- Tree Parameters ---
         const startX = canvasWidth / 2;
         const startY = 50; // Start near the bottom
         const initialLength = 150; // Length of the trunk
         const maxDepth = 11;       // Recursion depth (controls complexity)
         const angle = Math.PI / 2; // Start pointing straight up (90 degrees in radians)
         const branchAngle = Math.PI / 7; // Angle between branches (adjust for different looks)
         const lengthScale = 0.75;   // How much shorter each branch becomes
         const pointsPerSegment = 5; // Number of points to draw per branch segment (for density)
         const minLength = 2;       // Minimum branch length to draw
         // --- End Tree Parameters ---

         // --- Color Function ---
         // Color based on depth, cycling through hues
         function getColor(depth) {
             const hue = (depth * 30) % 360; // Cycle through hues
             const saturation = 90 + Math.random() * 10; // High saturation with slight variance
             const lightness = 50 + (depth / maxDepth) * 20; // Get slightly lighter towards tips
             return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
         }
         // --- End Color Function ---


         function generateBranch(x1, y1, currentAngle, length, depth) {
             if (depth > maxDepth || length < minLength) {
                 return;
             }

             // Calculate end point of the current branch
             const x2 = x1 + Math.cos(currentAngle) * length;
             const y2 = y1 + Math.sin(currentAngle) * length;

             // Generate points along the line segment for visual density
             const branchColor = getColor(depth);
             for (let i = 0; i < pointsPerSegment; i++) {
                 const t = i / (pointsPerSegment - 1); // Interpolation factor (0 to 1)
                 const px = x1 + (x2 - x1) * t;
                 const py = y1 + (y2 - y1) * t;

                 // Add slight random offset for a more organic look (optional)
                 const offsetX = (Math.random() - 0.5) * 0.5 * (maxDepth - depth);
                 const offsetY = (Math.random() - 0.5) * 0.5 * (maxDepth - depth);


                 data.push({
                     x: px + offsetX,
                     y: py + offsetY,
                     color: branchColor
                 });
             }

             // Recursive calls for the next level branches
             // Add slight randomness to angle and length for organic look
             const angleVariance = (Math.random() - 0.5) * (branchAngle * 0.1);
             const lengthVariance = 1.0 + (Math.random() - 0.5) * 0.1;

             // Left Branch
             generateBranch(x2, y2, currentAngle - branchAngle + angleVariance, length * lengthScale * lengthVariance, depth + 1);
             // Right Branch
             generateBranch(x2, y2, currentAngle + branchAngle + angleVariance, length * lengthScale * lengthVariance, depth + 1);
         }

         // Start the recursion
         generateBranch(startX, startY, angle, initialLength, 0);

         console.log("Generated points:", data.length); // Log number of points for performance check
         return data;
     }
     */
    static func generateSierpinskiTreeData() -> [[String: Any]] {
        var data: [[String: Any]] = []
        let canvasWidth = 800
        let canvasHeight = 800
        
        // --- Tree Parameters ---
        let startX = canvasWidth / 2
        let startY = 50 // Start near the bottom
        let initialLength = 150 // Length of the trunk
        let maxDepth = 11       // Recursion depth (controls complexity)
        let angle = Double.pi / 2 // Start pointing straight up (90 degrees in radians)
        let branchAngle = Double.pi / 7 // Angle between branches (adjust for different looks)
        let lengthScale = 0.75   // How much shorter each branch becomes
        let pointsPerSegment = 5 // Number of points to draw per branch segment (for density)
        let minLength = 2       // Minimum branch length to draw
        // --- End Tree Parameters ---
        
        // --- Color Function ---
        // Color based on depth, cycling through hues
        func getColor(depth: Int) -> String {
            let hue = (depth * 30) % 360 // Cycle through hues
            let saturation = 90 + Double.random(in: 0...10) // High saturation with slight variance
            let lightness = 50 + (Double(depth) / Double(maxDepth)) * 20 // Get slightly lighter towards tips
            return "hsl(\(hue), \(saturation)%, \(lightness)%)"
        }
        // --- End Color Function ---
        
        func generateBranch(x1: Double, y1: Double, currentAngle: Double, length: Double, depth: Int) {
            if depth > maxDepth || length < Double(minLength) {
                return
            }
            
            // Calculate end point of the current branch
            let x2 = x1 + cos(currentAngle) * length
            let y2 = y1 + sin(currentAngle) * length
            
            // Generate points along the line segment for visual density
            let branchColor = getColor(depth: depth)
            for i in 0..<pointsPerSegment {
                let t = Double(i) / Double(pointsPerSegment - 1) // Interpolation factor (0 to 1)
                let px = x1 + (x2 - x1) * t
                let py = y1 + (y2 - y1) * t
                
                // Add slight random offset for a more organic look (optional)
                let offsetX = (Double.random(in: 0...1) - 0.5) * 0.5 * Double(maxDepth - depth)
                let offsetY = (Double.random(in: 0...1) - 0.5) * 0.5 * Double(maxDepth - depth)
                
                data.append([
                    "x": px + offsetX,
                    "y": py + offsetY,
                    "color": branchColor
                ])
            }
            
            // Recursive calls for the next level branches
            // Add slight randomness to angle and length for organic look
            let angleVariance = (Double.random(in: 0...1) - 0.5) * (branchAngle * 0.1)
            let lengthVariance = 1.0 + (Double.random(in: 0...1) - 0.5) * 0.1
            
            // Left Branch
            generateBranch(x1: x2, y1: y2, currentAngle: currentAngle - branchAngle + angleVariance,
                         length: length * lengthScale * lengthVariance, depth: depth + 1)
            // Right Branch
            generateBranch(x1: x2, y1: y2, currentAngle: currentAngle + branchAngle + angleVariance,
                         length: length * lengthScale * lengthVariance, depth: depth + 1)
        }
        
        // Start the recursion
        generateBranch(x1: Double(startX), y1: Double(startY), currentAngle: angle, length: Double(initialLength), depth: 0)
        
        print("Generated points: \(data.count)") // Log number of points for performance check
        return data
    }
    
    
    
    /**
     function generateSierpinskiTriangleData() {
         const data = [];
         const canvasSize = 800;
         const padding = 50; // 边距

         // --- Triangle Parameters ---
         const maxDepth = 8; // 控制递归深度 (7-9 通常效果不错)
         // --- End Triangle Parameters ---

         // --- Vibrant Color Function (可复用或微调) ---
         function getColor(depth, maxDepth, x, y) { // 添加 x, y 坐标以供颜色变化
             const t = depth / maxDepth;

             // 霓虹/宇宙风格
             const freq1 = 0.3, phase1 = 1;
             const freq2 = 0.35, phase2 = 2;
             const freq3 = 0.4, phase3 = 4;

             // 基于位置的轻微扰动
             const posFactorX = x / canvasSize * 0.3;
             const posFactorY = y / canvasSize * 0.3;

             let r = Math.sin(freq1 * depth + phase1 + posFactorX) * 127 + 128;
             let g = Math.sin(freq2 * depth + phase2 + posFactorY) * 127 + 128;
             let b = Math.sin(freq3 * depth + phase3) * 127 + 128;

             // 亮度增强
             const brightnessBoost = Math.pow(t, 0.5);
             r = r * (0.7 + brightnessBoost * 0.8);
             g = g * (0.7 + brightnessBoost * 0.8);
             b = b * (0.7 + brightnessBoost * 0.8);

             r = Math.max(0, Math.min(255, Math.floor(r)));
             g = Math.max(0, Math.min(255, Math.floor(g)));
             b = Math.max(0, Math.min(255, Math.floor(b)));

             return `rgb(${r}, ${g}, ${b})`;
         }
         // --- End Color Function ---

         // 递归函数，参数为当前三角形的三个顶点和深度
         function generateTriangle(v1, v2, v3, depth) {
             // Base Case: 达到最大深度，绘制当前三角形的顶点
             if (depth >= maxDepth) {
                 const color1 = getColor(depth, maxDepth, v1.x, v1.y);
                 const color2 = getColor(depth, maxDepth, v2.x, v2.y);
                 const color3 = getColor(depth, maxDepth, v3.x, v3.y);
                 // 可以为每个顶点计算颜色，或者使用统一颜色
                 data.push({ x: v1.x, y: v1.y, color: color1 });
                 data.push({ x: v2.x, y: v2.y, color: color2 });
                 data.push({ x: v3.x, y: v3.y, color: color3 });
                 return;
             }

             // Recursive Step: 计算三条边的中点
             const m12 = { x: (v1.x + v2.x) / 2, y: (v1.y + v2.y) / 2 };
             const m23 = { x: (v2.x + v3.x) / 2, y: (v2.y + v3.y) / 2 };
             const m31 = { x: (v3.x + v1.x) / 2, y: (v3.y + v1.y) / 2 };

             // 对三个角落的子三角形进行递归调用
             generateTriangle(v1, m12, m31, depth + 1); // 包含顶点 v1 的子三角形
             generateTriangle(m12, v2, m23, depth + 1); // 包含顶点 v2 的子三角形
             generateTriangle(m31, m23, v3, depth + 1); // 包含顶点 v3 的子三角形
             // 注意：中间的三角形 (m12, m23, m31) 被跳过，不进行绘制或递归
         }

         // --- 定义初始大三角形的顶点 ---
         //  (使其大致居中并填满画布，Y轴向上)
         const baseWidth = canvasSize - 2 * padding;
         const triangleHeight = (Math.sqrt(3) / 2) * baseWidth;

         // 顶点1 (顶部)
         const topVertex = { x: canvasSize / 2, y: padding + triangleHeight };
         // 顶点2 (左下)
         const leftVertex = { x: padding, y: padding };
         // 顶点3 (右下)
         const rightVertex = { x: canvasSize - padding, y: padding };

         // 开始递归生成
         generateTriangle(topVertex, leftVertex, rightVertex, 0);

         console.log("Generated points:", data.length);
         return data;
     }
     */

    static func generateSierpinskiTriangleData() -> [[String: Any]] {
        var data: [[String: Any]] = []
        let canvasSize = 800
        let padding = 50 // 边距
        
        // --- Triangle Parameters ---
        let maxDepth = 8 // 控制递归深度 (7-9 通常效果不错)
        // --- End Triangle Parameters ---
        
        // --- Vibrant Color Function (可复用或微调) ---
        func getColor(depth: Int, maxDepth: Int, x: Double, y: Double) -> String { // 添加 x, y 坐标以供颜色变化
            let t = Double(depth) / Double(maxDepth)
            
            // 霓虹/宇宙风格
            let freq1: Double = 0.3, phase1: Double = 1
            let freq2: Double = 0.35, phase2: Double = 2
            let freq3: Double = 0.4, phase3: Double = 4
            
            // 基于位置的轻微扰动
            let posFactorX = x / Double(canvasSize) * 0.3
            let posFactorY = y / Double(canvasSize) * 0.3
            
            var r = sin(freq1 * Double(depth) + phase1 + posFactorX) * 127 + 128
            var g = sin(freq2 * Double(depth) + phase2 + posFactorY) * 127 + 128
            var b = sin(freq3 * Double(depth) + phase3) * 127 + 128
            
            // 亮度增强
            let brightnessBoost = pow(t, 0.5)
            r = r * (0.7 + brightnessBoost * 0.8)
            g = g * (0.7 + brightnessBoost * 0.8)
            b = b * (0.7 + brightnessBoost * 0.8)
            
            r = max(0, min(255, r))
            g = max(0, min(255, g))
            b = max(0, min(255, b))
            
            return "rgb(\(Int(r)), \(Int(g)), \(Int(b)))"
        }
        // --- End Color Function ---
        
        // 顶点结构体
        struct Vertex {
            let x: Double
            let y: Double
        }
        
        // 递归函数，参数为当前三角形的三个顶点和深度
        func generateTriangle(v1: Vertex, v2: Vertex, v3: Vertex, depth: Int) {
            // Base Case: 达到最大深度，绘制当前三角形的顶点
            if depth >= maxDepth {
                let color1 = getColor(depth: depth, maxDepth: maxDepth, x: v1.x, y: v1.y)
                let color2 = getColor(depth: depth, maxDepth: maxDepth, x: v2.x, y: v2.y)
                let color3 = getColor(depth: depth, maxDepth: maxDepth, x: v3.x, y: v3.y)
                // 可以为每个顶点计算颜色，或者使用统一颜色
                data.append(["x": v1.x, "y": v1.y, "color": color1])
                data.append(["x": v2.x, "y": v2.y, "color": color2])
                data.append(["x": v3.x, "y": v3.y, "color": color3])
                return
            }
            
            // Recursive Step: 计算三条边的中点
            let m12 = Vertex(x: (v1.x + v2.x) / 2, y: (v1.y + v2.y) / 2)
            let m23 = Vertex(x: (v2.x + v3.x) / 2, y: (v2.y + v3.y) / 2)
            let m31 = Vertex(x: (v3.x + v1.x) / 2, y: (v3.y + v1.y) / 2)
            
            // 对三个角落的子三角形进行递归调用
            generateTriangle(v1: v1, v2: m12, v3: m31, depth: depth + 1) // 包含顶点 v1 的子三角形
            generateTriangle(v1: m12, v2: v2, v3: m23, depth: depth + 1) // 包含顶点 v2 的子三角形
            generateTriangle(v1: m31, v2: m23, v3: v3, depth: depth + 1) // 包含顶点 v3 的子三角形
            // 注意：中间的三角形 (m12, m23, m31) 被跳过，不进行绘制或递归
        }
        
        // --- 定义初始大三角形的顶点 ---
        //  (使其大致居中并填满画布，Y轴向上)
        let baseWidth = Double(canvasSize - 2 * padding)
        let triangleHeight = (sqrt(3) / 2) * baseWidth
        
        // 顶点1 (顶部)
        let topVertex = Vertex(x: Double(canvasSize) / 2, y: Double(padding) + triangleHeight)
        // 顶点2 (左下)
        let leftVertex = Vertex(x: Double(padding), y: Double(padding))
        // 顶点3 (右下)
        let rightVertex = Vertex(x: Double(canvasSize - padding), y: Double(padding))
        
        // 开始递归生成
        generateTriangle(v1: topVertex, v2: leftVertex, v3: rightVertex, depth: 0)
        
        print("Generated points: \(data.count)") // 日志记录生成的点数
        return data
    }
    
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
     */
    class func generateSierpinskiCarpetData() -> [Any] {
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
}
