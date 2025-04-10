//
//  AAFractalJuliaSetData.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/4/9.
//

import Foundation

class AAFractalJuliaSetData: NSObject {

    /**
     const canvasWidth = 500;
     const canvasHeight = 500;
     const maxIterations = 50; // 可以调整迭代次数影响细节和性能

     // --- Julia Set Parameters (初始值，会被滑块覆盖) ---
     let currentCx = -0.8;
     let currentCy = 0.156;
     // --- Complex Plane Mapping ---
     // 决定画布像素对应到复平面上的区域
     const xMin = -2.0;
     const xMax = 2.0;
     const yMin = -2.0;
     const yMax = 2.0;
     const xRange = xMax - xMin;
     const yRange = yMax - yMin;


     // --- RGB Color Function ---
     function getColor(iterations, maxIter, zReal, zImag) {
         if (iterations === maxIter) {
             return 'rgb(0, 0, 0)'; // Set interior is black
         }

         // Smooth coloring based on escape time and final magnitude
         // log(log(|Z|))/log(2) is common, need magnitude |Z| = sqrt(zReal^2 + zImag^2)
         // Use |Z|^2 = zReal^2 + zImag^2 to avoid sqrt until log
         const magnitudeSquared = zReal * zReal + zImag * zImag;
         // Handle potential log(0) or log(<1) issues if magnitude is very small near boundary
         const logMag = magnitudeSquared > 1.0e-10 ? Math.log(magnitudeSquared) / 2.0 : -10.0; // log(|Z|)
         const smooth = iterations + 1 - Math.log(logMag) / Math.log(2.0);

         const t = Math.max(0, Math.min(1, smooth / maxIter)); // Normalized smooth value [0, 1]

         // RGB Color generation using sine waves (adjust frequencies/phases for different looks)
         const freq1 = 0.15, phase1 = 0.5;
         const freq2 = 0.18, phase2 = 1.5;
         const freq3 = 0.22, phase3 = 3.0;

         // Use 'smooth' directly for more variation than normalized 't'
         let r = Math.sin(freq1 * smooth + phase1) * 127 + 128;
         let g = Math.sin(freq2 * smooth + phase2) * 127 + 128;
         let b = Math.sin(freq3 * smooth + phase3) * 127 + 128;

         // Optional: Add brightness boost based on t (closer to boundary = brighter)
         const brightness = 0.6 + Math.pow(t, 0.4) * 0.6; // Adjust base and boost factor
         r *= brightness;
         g *= brightness;
         b *= brightness;

         // Clamp to 0-255 and format as rgb string
         r = Math.max(0, Math.min(255, Math.floor(r)));
         g = Math.max(0, Math.min(255, Math.floor(g)));
         b = Math.max(0, Math.min(255, Math.floor(b)));

         return `rgb(${r}, ${g}, ${b})`;
     }
     // --- End Color Function ---


     function generateJuliaData(cx, cy) {
         console.time("Generate Julia Data");
         const data = [];

         for (let px = 0; px < canvasWidth; px++) {
             for (let py = 0; py < canvasHeight; py++) {
                 // Map pixel coordinate (px, py) to complex number z0
                 // Highcharts Y=0 is bottom, so map py inversely if needed, but here we map directly
                 // and let Highcharts handle its coordinate system for plotting (px, py)
                 const z0Real = xMin + (px / canvasWidth) * xRange;
                 // Y-axis mapping: pixel y=0 (top) maps to yMax, pixel y=height (bottom) maps to yMin
                 const z0Imag = yMax - (py / canvasHeight) * yRange;

                 let zReal = z0Real;
                 let zImag = z0Imag;
                 let iterations = 0;

                 while (iterations < maxIterations && (zReal * zReal + zImag * zImag) < 4) {
                     // z = z^2 + c
                     const tempReal = zReal * zReal - zImag * zImag + cx;
                     zImag = 2 * zReal * zImag + cy;
                     zReal = tempReal;
                     iterations++;
                 }

                 const color = getColor(iterations, maxIterations, zReal, zImag);
                 // We plot using pixel coordinates (px, py) directly in Highcharts
                 data.push({
                     x: px,
                     y: py,
                     color: color
                 });
             }
         }
         console.timeEnd("Generate Julia Data");
         console.log("Generated points:", data.length);
         return data;
     }

     // --- Highcharts Chart Initialization ---
     const chart = Highcharts.chart('container', {
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
             text: 'Interactive Julia Set',
             style: { color: '#e0f0ff', fontSize: '22px', textShadow: '0 0 5px #ffffff' }
         },
         xAxis: { min: 0, max: canvasWidth, visible: false, startOnTick: false, endOnTick: false },
         yAxis: { min: 0, max: canvasHeight, visible: false, startOnTick: false, endOnTick: false },
         legend: { enabled: false },
         plotOptions: {
             scatter: {
                 marker: {
                     radius: 0.5, // Use radius 0.5 for square pixels filling the space
                     symbol: 'square' // Square markers for pixel grid
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
             name: 'Julia',
             data: generateJuliaData(currentCx, currentCy), // Initial generation
             turboThreshold: 0, // Disable Highcharts internal thresholding
             // animation: false // Faster updates
         }],
         credits: { enabled: false }
     });
     */
    static func generateJuliaSetData() -> [[String: Any]] {
        let canvasWidth = 800
        let canvasHeight = 800
        let maxIterations = 50 // 可以调整迭代次数影响细节和性能
        
        // --- Julia Set Parameters (初始值，会被滑块覆盖) ---
        let currentCx = -0.8
        let currentCy = 0.156
        // --- Complex Plane Mapping ---
        // 决定画布像素对应到复平面上的区域
        let xMin = -2.0
        let xMax = 2.0
        let yMin = -2.0
        let yMax = 2.0
        let xRange = xMax - xMin
        let yRange = yMax - yMin
        
        // 生成Julia集的数据
        let juliaData = generateJuliaData(cx: currentCx, cy: currentCy,
                                          canvasWidth: canvasWidth,
                                          canvasHeight: canvasHeight,
                                          maxIterations: maxIterations,
                                          xMin: xMin, xMax: xMax,
                                          yMin: yMin, yMax: yMax)
        
        return juliaData
    }
    
    
    
    
    // --- RGB Color Function ---
    static func getColor(iterations: Int, maxIter: Int, zReal: Double, zImag: Double) -> String {
        if iterations == maxIter {
            return "rgb(0, 0, 0)" // Set interior is black
        }
        
        // Smooth coloring based on escape time and final magnitude
        // log(log(|Z|))/log(2) is common, need magnitude |Z| = sqrt(zReal^2 + zImag^2)
        // Use |Z|^2 = zReal^2 + zImag^2 to avoid sqrt until log
        let magnitudeSquared = zReal * zReal + zImag * zImag
        // Handle potential log(0) or log(<1) issues if magnitude is very small near boundary
        let logMag = magnitudeSquared > 1.0e-10 ? log(magnitudeSquared) / 2.0 : -10.0 // log(|Z|)
        let smooth = Double(iterations) + 1.0 - log(logMag) / log(2.0)
        
        let t = max(0, min(1, smooth / Double(maxIter))) // Normalized smooth value [0, 1]
        
        // RGB Color generation using sine waves (adjust frequencies/phases for different looks)
        let freq1 = 0.15, phase1 = 0.5
        let freq2 = 0.18, phase2 = 1.5
        let freq3 = 0.22, phase3 = 3.0
        
        // Use 'smooth' directly for more variation than normalized 't'
        var r = sin(freq1 * smooth + phase1) * 127 + 128
        var g = sin(freq2 * smooth + phase2) * 127 + 128
        var b = sin(freq3 * smooth + phase3) * 127 + 128
        
        // Optional: Add brightness boost based on t (closer to boundary = brighter)
        let brightness = 0.6 + pow(t, 0.4) * 0.6 // Adjust base and boost factor
        r *= brightness
        g *= brightness
        b *= brightness
        
        // Clamp to 0-255 and format as rgb string
        r = max(0, min(255, floor(r)))
        g = max(0, min(255, floor(g)))
        b = max(0, min(255, floor(b)))
        
        return "rgb(\(Int(r)), \(Int(g)), \(Int(b)))"
    }
    // --- End Color Function ---
    
    static func generateJuliaData(cx: Double, cy: Double, canvasWidth: Int, canvasHeight: Int,
                                  maxIterations: Int, xMin: Double, xMax: Double, yMin: Double, yMax: Double) -> [[String: Any]] {
        print("Generate Julia Data - Started")
        
        let xRange = xMax - xMin
        let yRange = yMax - yMin
        var data: [[String: Any]] = []
        
        for px in 0..<canvasWidth {
            for py in 0..<canvasHeight {
                // Map pixel coordinate (px, py) to complex number z0
                // Highcharts Y=0 is bottom, so map py inversely if needed, but here we map directly
                // and let Highcharts handle its coordinate system for plotting (px, py)
                let z0Real = xMin + (Double(px) / Double(canvasWidth)) * xRange
                // Y-axis mapping: pixel y=0 (top) maps to yMax, pixel y=height (bottom) maps to yMin
                let z0Imag = yMax - (Double(py) / Double(canvasHeight)) * yRange
                
                var zReal = z0Real
                var zImag = z0Imag
                var iterations = 0
                
                while iterations < maxIterations && (zReal * zReal + zImag * zImag) < 4 {
                    // z = z^2 + c
                    let tempReal = zReal * zReal - zImag * zImag + cx
                    zImag = 2 * zReal * zImag + cy
                    zReal = tempReal
                    iterations += 1
                }
                
                let color = getColor(iterations: iterations, maxIter: maxIterations, zReal: zReal, zImag: zImag)
                // We plot using pixel coordinates (px, py) directly in Highcharts
                data.append([
                    "x": px,
                    "y": py,
                    "color": color
                ])
            }
        }
        
        print("Generate Julia Data - Completed")
        print("Generated points: \(data.count)")
        return data
    }
}
