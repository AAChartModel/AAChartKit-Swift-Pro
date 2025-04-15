import UIKit
import Foundation // For Double.pi, cos, sin, etc.

class AAExtraFractalChartData: NSObject {

    // MARK: - Dragon Curve (Iterated Function System - Geometric)

    /**
     Generates points for the Dragon Curve, automatically scaling and centering it.
     */
    static func generateDragonCurveData(iterations: Int = 12, targetWidth: CGFloat = 700, targetHeight: CGFloat = 700, canvasWidth: CGFloat = 800, canvasHeight: CGFloat = 800) -> [[String: Any]] {
        var rawPoints: [CGPoint] = [CGPoint(x: 0, y: 0)] // Start at origin for raw calculation
        var currentAngle: CGFloat = 0.0
        let baseSegmentLength: CGFloat = 1.0 // Use base length for raw coordinates
        var turnSequence: [Int] = []

        // Build the turn sequence (same as before)
        for _ in 0..<iterations {
            var nextSequence = turnSequence
            nextSequence.append(1)
            let reversedTurns = turnSequence.reversed().map { -$0 }
            nextSequence.append(contentsOf: reversedTurns)
            turnSequence = nextSequence
        }

        // Generate raw points without scaling/offset
        var currentPoint = rawPoints[0]
        var minX = currentPoint.x, maxX = currentPoint.x
        var minY = currentPoint.y, maxY = currentPoint.y

        for turn in turnSequence {
            currentAngle += CGFloat(turn) * (Double.pi / 2.0)
            let nextX = currentPoint.x + baseSegmentLength * cos(currentAngle)
            let nextY = currentPoint.y + baseSegmentLength * sin(currentAngle)
            currentPoint = CGPoint(x: nextX, y: nextY)
            rawPoints.append(currentPoint)

            // Update bounds
            minX = min(minX, currentPoint.x)
            maxX = max(maxX, currentPoint.x)
            minY = min(minY, currentPoint.y)
            maxY = max(maxY, currentPoint.y)
        }

        // Calculate scale factor and offset
        let rawWidth = maxX - minX
        let rawHeight = maxY - minY
        var scaleFactor: CGFloat = 1.0

        if rawWidth > 0 && rawHeight > 0 {
             scaleFactor = min(targetWidth / rawWidth, targetHeight / rawHeight)
        } else if rawWidth > 0 {
            scaleFactor = targetWidth / rawWidth
        } else if rawHeight > 0 {
            scaleFactor = targetHeight / rawHeight
        }


        // Center the scaled drawing within the canvas
        let scaledWidth = rawWidth * scaleFactor
        let scaledHeight = rawHeight * scaleFactor
        let offsetX = (canvasWidth - scaledWidth) / 2.0 - minX * scaleFactor
        let offsetY = (canvasHeight - scaledHeight) / 2.0 - minY * scaleFactor

        // Generate final data with scaling, offset, and color
        var data: [[String: Any]] = []
        let startColor = UIColor.cyan
        let endColor = UIColor.magenta

        var previousScaledPoint: CGPoint? = nil

        for (index, rawPoint) in rawPoints.enumerated() {
            let scaledX = rawPoint.x * scaleFactor + offsetX
            let scaledY = rawPoint.y * scaleFactor + offsetY
            let scaledPoint = CGPoint(x: scaledX, y: scaledY)

            let t = CGFloat(index) / CGFloat(rawPoints.count - 1)
            let color = interpolateColor(from: startColor, to: endColor, with: t)
            let colorHex = colorToHexString(color)

            // Add points along the segment from the previous scaled point
            if let prevPoint = previousScaledPoint {
                 let pointsPerSegment = 2 // Add points between calculated vertices
                 for i in 1...pointsPerSegment {
                     let segmentT = CGFloat(i) / CGFloat(pointsPerSegment)
                     let px = prevPoint.x + (scaledPoint.x - prevPoint.x) * segmentT
                     let py = prevPoint.y + (scaledPoint.y - prevPoint.y) * segmentT
                      // Basic bounds check
                     if px >= 0 && px <= canvasWidth && py >= 0 && py <= canvasHeight {
                         data.append(["x": px, "y": py, "color": colorHex])
                     }
                 }
            } else {
                 // Add the very first point
                 if scaledX >= 0 && scaledX <= canvasWidth && scaledY >= 0 && scaledY <= canvasHeight {
                    data.append(["x": scaledX, "y": scaledY, "color": colorHex])
                 }
            }
             previousScaledPoint = scaledPoint
        }


        print("Generated Dragon Curve points: \(data.count)")
        return data
    }

    // MARK: - Levy C Curve (Iterated Function System - Geometric)

    /**
     Generates points for the Levy C Curve recursively.
     */
    static func generateLevyCCurveData(iterations: Int = 10) -> [[String: Any]] {
        var data: [[String: Any]] = []
        let startPoint = CGPoint(x: 250, y: 300)
        let endPoint = CGPoint(x: 550, y: 300)
        let startColor = UIColor.yellow
        let endColor = UIColor.blue

        func generateSegment(p1: CGPoint, p2: CGPoint, depth: Int) {
            if depth == 0 {
                // Base case: Add points along the final segment
                let numPoints = 3
                let segmentColor = interpolateColor(from: startColor, to: endColor, with: CGFloat.random(in: 0...1)) // Randomize color slightly
                for i in 0...numPoints {
                    let t = CGFloat(i) / CGFloat(numPoints)
                    data.append([
                        "x": p1.x + (p2.x - p1.x) * t,
                        "y": p1.y + (p2.y - p1.y) * t,
                        "color": colorToHexString(segmentColor)
                    ])
                }
                return
            }

            // Calculate the midpoint rotated by 45 degrees
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            let midX = p1.x + (dx - dy) / 2
            let midY = p1.y + (dx + dy) / 2
            let midPoint = CGPoint(x: midX, y: midY)

            generateSegment(p1: p1, p2: midPoint, depth: depth - 1)
            generateSegment(p1: midPoint, p2: p2, depth: depth - 1)
        }

        generateSegment(p1: startPoint, p2: endPoint, depth: iterations)
        print("Generated Levy C Curve points: \(data.count)")
        return data
    }

    // MARK: - Burning Ship Fractal (Escape Time)

    /**
     Generates points for the Burning Ship fractal. Similar to Mandelbrot but uses absolute values.
     */
    static func generateBurningShipData() -> [[String: Any]] {
        let width = 800
        let height = 800
        let maxIterations = 80
        var data: [[String: Any]] = []

        // Define the region of the complex plane to view
        let minReal = -2.0
        let maxReal = 1.0
        let minImag = -1.5
        let maxImag = 1.5
        let realRange = maxReal - minReal
        let imagRange = maxImag - minImag

        // Color mapping function (adjust for desired aesthetics)
        func getColor(iterations: Int) -> String {
            if iterations == maxIterations {
                return "#000000" // Inside the set
            }
            // Fiery color scheme
            let t = Double(iterations) / Double(maxIterations)
            let r = Int(min(255, 50 + 205 * pow(t, 0.5)))       // Start yellow/orange
            let g = Int(min(255, 255 * pow(t, 1.5)))      // Increase green slower
            let b = Int(min(255, 50 * pow(t, 3.0)))        // Increase blue very slow
            return "rgb(\(r),\(g),\(b))"
        }

        for px in 0..<width {
            for py in 0..<height {
                // Map pixel coordinates to complex plane coordinates
                let real = minReal + (Double(px) / Double(width)) * realRange
                let imag = minImag + (Double(py) / Double(height)) * imagRange

                var zReal: Double = 0
                var zImag: Double = 0
                var iterations = 0

                while iterations < maxIterations && zReal * zReal + zImag * zImag < 4.0 {
                    // Burning Ship iteration: z = (|Re(z)| + i|Im(z)|)^2 + c
                    let tempReal = zReal * zReal - zImag * zImag + real
                    let tempImag = abs(2.0 * zReal * zImag) + imag // Key difference: abs()
                    zReal = tempReal
                    zImag = tempImag
                    iterations += 1
                }

                data.append([
                    "x": px,
                    "y": py, // Highcharts Y=0 is at the bottom, matches calculation
                    "color": getColor(iterations: iterations)
                ])
            }
        }
        print("Generated Burning Ship points: \(data.count)")
        return data
    }

    // MARK: - Newton Fractal (Escape Time - Root Finding)

    /**
     Generates points for the Newton fractal for the polynomial z^3 - 1 = 0.
     Points are colored based on which root they converge to.
     */
    static func generateNewtonFractalData() -> [[String: Any]] {
        let width = 800
        let height = 800
        let maxIterations = 50
        let tolerance = 0.001 // Convergence tolerance
        var data: [[String: Any]] = []

        // Define the region of the complex plane
        let minX = -1.5
        let maxX = 1.5
        let minY = -1.5
        let maxY = 1.5
        let rangeX = maxX - minX
        let rangeY = maxY - minY

        // Roots of z^3 - 1 = 0
        let roots: [(re: Double, im: Double)] = [
            (re: 1.0, im: 0.0),
            (re: -0.5, im: sqrt(3.0) / 2.0),
            (re: -0.5, im: -sqrt(3.0) / 2.0)
        ]
        // Assign colors to roots
        let rootColors = ["rgb(255, 80, 80)", "rgb(80, 255, 80)", "rgb(80, 80, 255)"] // Red, Green, Blue

        // Complex number arithmetic helpers
        func complexAdd(_ a: (re: Double, im: Double), _ b: (re: Double, im: Double)) -> (re: Double, im: Double) {
            return (re: a.re + b.re, im: a.im + b.im)
        }
        func complexSubtract(_ a: (re: Double, im: Double), _ b: (re: Double, im: Double)) -> (re: Double, im: Double) {
            return (re: a.re - b.re, im: a.im - b.im)
        }
        func complexMultiply(_ a: (re: Double, im: Double), _ b: (re: Double, im: Double)) -> (re: Double, im: Double) {
            return (re: a.re * b.re - a.im * b.im, im: a.re * b.im + a.im * b.re)
        }
        func complexDivide(_ a: (re: Double, im: Double), _ b: (re: Double, im: Double)) -> (re: Double, im: Double) {
            let denom = b.re * b.re + b.im * b.im
            if denom == 0 { return (re: Double.infinity, im: Double.infinity) } // Avoid division by zero
            return (re: (a.re * b.re + a.im * b.im) / denom, im: (a.im * b.re - a.re * b.im) / denom)
        }
        func complexMagnitudeSq(_ a: (re: Double, im: Double)) -> Double {
            return a.re * a.re + a.im * a.im
        }

        // f(z) = z^3 - 1
        func f(_ z: (re: Double, im: Double)) -> (re: Double, im: Double) {
            let z2 = complexMultiply(z, z)
            let z3 = complexMultiply(z2, z)
            return complexSubtract(z3, (re: 1.0, im: 0.0))
        }

        // f'(z) = 3z^2
        func fPrime(_ z: (re: Double, im: Double)) -> (re: Double, im: Double) {
            let z2 = complexMultiply(z, z)
            return (re: 3.0 * z2.re, im: 3.0 * z2.im)
        }

        for px in 0..<width {
            for py in 0..<height {
                // Map pixel to complex plane (adjusting for typical coordinate systems)
                var z = (re: minX + (Double(px) / Double(width)) * rangeX,
                         im: maxY - (Double(py) / Double(height)) * rangeY) // Y is often inverted

                var iterations = 0
                var color = "#000000" // Default color (e.g., for non-convergence)

                while iterations < maxIterations {
                    let fz = f(z)
                    let fpz = fPrime(z)

                    // Check for convergence to a root
                    var converged = false
                    for (index, root) in roots.enumerated() {
                        if complexMagnitudeSq(complexSubtract(z, root)) < tolerance * tolerance {
                            // Converged to this root
                            // Color based on root and iteration count (for brightness/shade)
                            let baseColor = hexToUIColor(hex: rootColors[index])
                            let brightness = 1.0 - 0.8 * (Double(iterations) / Double(maxIterations))
                            color = colorToHexString(adjustBrightness(color: baseColor, factor: CGFloat(brightness)))
                            converged = true
                            break
                        }
                    }
                    if converged { break }

                    // Check if derivative is zero (or close to it)
                     if complexMagnitudeSq(fpz) < 1e-12 {
                         // Avoid division by zero, mark as non-converging or a specific color
                         color = "#444444" // Dark grey for critical points/slow convergence
                         break
                     }

                    // Newton's method iteration: z = z - f(z) / f'(z)
                    z = complexSubtract(z, complexDivide(fz, fpz))
                    iterations += 1
                }
                 if iterations == maxIterations {
                     color = "#111111" // Black or very dark if max iterations reached without convergence
                 }


                data.append([
                    "x": px,
                    "y": py, // Highcharts Y=0 is at the bottom
                    "color": color
                ])
            }
        }
        print("Generated Newton Fractal points: \(data.count)")
        return data
    }

    // MARK: - Vicsek Fractal (Box Fractal)

    /**
     Generates points for the Vicsek fractal (a box-like structure).
     */
    static func generateVicsekFractalData(iterations: Int = 5) -> [[String: Any]] {
        var data: [[String: Any]] = []
        let canvasSize: CGFloat = 800

        // Color function based on depth
        func getColor(depth: Int, maxDepth: Int) -> String {
            let hue = 240 + Double(depth) / Double(maxDepth) * 60 // Blue to Purple range
            let saturation = 0.7 + Double.random(in: 0...0.3)
            let lightness = 0.4 + Double(depth) / Double(maxDepth) * 0.3
            return hslToHexString(h: hue, s: saturation, l: lightness)
        }

        func generateVicsek(x: CGFloat, y: CGFloat, size: CGFloat, depth: Int) {
            if depth == 0 {
                // Base case: Draw points representing the final square
                let numPoints = 5 // Points per square side (approx)
                let step = size / CGFloat(numPoints)
                let squareColor = getColor(depth: iterations, maxDepth: iterations) // Use final depth

                // Add points for the square's center
                 data.append(["x": x + size / 2, "y": y + size / 2, "color": squareColor])
                // Optional: Add more points for density
                 for i in 0...numPoints {
                     let offset = CGFloat(i) * step
                     data.append(["x": x + offset, "y": y, "color": squareColor]) // Bottom
                     data.append(["x": x + offset, "y": y + size, "color": squareColor]) // Top
                     if i > 0 && i < numPoints { // Avoid duplicating corners
                         data.append(["x": x, "y": y + offset, "color": squareColor]) // Left
                         data.append(["x": x + size, "y": y + offset, "color": squareColor]) // Right
                     }
                 }
                return
            }

            let newSize = size / 3.0

            // Recursive calls for the 5 sub-squares (center and four corners)
            // Center square
            generateVicsek(x: x + newSize, y: y + newSize, size: newSize, depth: depth - 1)
            // Corner squares
            generateVicsek(x: x,           y: y,           size: newSize, depth: depth - 1) // Bottom-left
            generateVicsek(x: x + 2*newSize, y: y,           size: newSize, depth: depth - 1) // Bottom-right
            generateVicsek(x: x,           y: y + 2*newSize, size: newSize, depth: depth - 1) // Top-left
            generateVicsek(x: x + 2*newSize, y: y + 2*newSize, size: newSize, depth: depth - 1) // Top-right
        }

        generateVicsek(x: 0, y: 0, size: canvasSize, depth: iterations)
        print("Generated Vicsek Fractal points: \(data.count)")
        return data
    }


    // MARK: - Helper Functions (Color Interpolation, Conversion)

    private static func interpolateColor(from color1: UIColor, to color2: UIColor, with fraction: CGFloat) -> UIColor {
        let fraction = max(0, min(1, fraction)) // Clamp fraction between 0 and 1
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = r1 + (r2 - r1) * fraction
        let g = g1 + (g2 - g1) * fraction
        let b = b1 + (b2 - b1) * fraction
        let a = a1 + (a2 - a1) * fraction

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    private static func colorToHexString(_ color: UIColor) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    private static func hexToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray // Default color if hex is invalid
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

     private static func adjustBrightness(color: UIColor, factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness = max(0, min(1, brightness * factor))
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        // Fallback for non-HSB colors (e.g., grayscale) - adjust RGB components
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            red = max(0, min(1, red * factor))
            green = max(0, min(1, green * factor))
            blue = max(0, min(1, blue * factor))
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return color // Return original if conversion fails
    }

    private static func hslToHexString(h: Double, s: Double, l: Double) -> String {
        let color = UIColor(hue: CGFloat(h / 360.0), saturation: CGFloat(s), lightness: CGFloat(l), alpha: 1.0)
        return colorToHexString(color)
    }
}

// Helper extension for HSL support in UIColor (if not available natively)
extension UIColor {
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        let brightness = lightness + saturation * min(lightness, 1 - lightness)
        let saturationAdjusted = brightness == 0 ? 0 : 2 * (1 - lightness / brightness)
        self.init(hue: hue, saturation: saturationAdjusted, brightness: brightness, alpha: alpha)
    }
}
