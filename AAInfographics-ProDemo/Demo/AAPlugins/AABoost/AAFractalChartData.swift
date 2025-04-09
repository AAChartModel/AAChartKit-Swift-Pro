//
//  AAFractalChartData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/9.
//

import UIKit

class AAFractalChartData: NSObject {
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
    static func generateFractalTreeData() -> [[String: Any]] {
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
     function generateMandelbrot() {
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
    static func generateMandelbrot() -> [[String: Any]] {
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
}
