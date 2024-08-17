//
//  VectorLogoLayer.swift
//  loop_player
//
//  Created by Igor Shelopaev on 13.08.24.
//

import Foundation
import swiftui_loop_videoplayer

#if canImport(UIKit)
import UIKit

struct VectorLogoLayer: ShapeLayerBuilderProtocol{
    var id: UUID = .init()
    
    func build(with geometry: (frame: CGRect, bounds: CGRect)) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        // Set the initial path
        let initialPath = createApplePath(with: geometry.bounds)
        shapeLayer.path = initialPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.frame = geometry.bounds
        shapeLayer.position = CGPoint(x: geometry.frame.size.width / 2, y: geometry.frame.size.height / 2)
        
        // Animation for the path
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = initialPath.cgPath
        animation.toValue = createApplePath(with: geometry.bounds, scale: 1.2).cgPath // Scale up by 20%
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        shapeLayer.add(animation, forKey: nil)

        return shapeLayer
    }

    /// Helper function to create a UIBezierPath for the apple shape
    private func createApplePath(with bounds: CGRect, scale: CGFloat = 1.0) -> UIBezierPath {
        let path = UIBezierPath()
        let widthFactor = bounds.width * scale
        let heightFactor = bounds.height * scale
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        // Move and curves adjusted for scale
        path.move(to: CGPoint(x: centerX, y: centerY - heightFactor * 0.3))
        path.addCurve(to: CGPoint(x: centerX, y: centerY + heightFactor * 0.3),
                      controlPoint1: CGPoint(x: centerX + widthFactor * 0.2, y: centerY - heightFactor * 0.1),
                      controlPoint2: CGPoint(x: centerX + widthFactor * 0.4, y: centerY + heightFactor * 0.1))
        path.addCurve(to: CGPoint(x: centerX, y: centerY - heightFactor * 0.3),
                      controlPoint1: CGPoint(x: centerX - widthFactor * 0.4, y: centerY + heightFactor * 0.1),
                      controlPoint2: CGPoint(x: centerX - widthFactor * 0.2, y: centerY - heightFactor * 0.1))
        path.close()

        return path
    }
}
#elseif canImport(AppKit)
import AppKit

struct VectorLogoLayer: ShapeLayerBuilderProtocol {
    var id: UUID = .init()
    
    func build(with geometry: (frame: CGRect, bounds: CGRect)) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        // Set the initial path using NSBezierPath for macOS
        let initialPath = createApplePath(with: geometry.bounds)
        shapeLayer.path = initialPath.cgPath
        shapeLayer.fillColor = NSColor.red.cgColor
        shapeLayer.strokeColor = NSColor.green.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.frame = geometry.bounds
        shapeLayer.position = CGPoint(x: geometry.frame.size.width / 2, y: geometry.frame.size.height / 2)
        
        // Animation for the path
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = initialPath.cgPath
        animation.toValue = createApplePath(with: geometry.bounds, scale: 1.2).cgPath // Scale up by 20%
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        shapeLayer.add(animation, forKey: nil)

        return shapeLayer
    }

    /// Helper function to create a NSBezierPath for the apple shape
    private func createApplePath(with bounds: CGRect, scale: CGFloat = 1.0) -> NSBezierPath {
        let path = NSBezierPath()
        let widthFactor = bounds.width * scale
        let heightFactor = bounds.height * scale
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        // Move and curves adjusted for scale
        path.move(to: CGPoint(x: centerX, y: centerY - heightFactor * 0.3))
        path.curve(to: CGPoint(x: centerX, y: centerY + heightFactor * 0.3),
                   controlPoint1: CGPoint(x: centerX + widthFactor * 0.2, y: centerY - heightFactor * 0.1),
                   controlPoint2: CGPoint(x: centerX + widthFactor * 0.4, y: centerY + heightFactor * 0.1))
        path.curve(to: CGPoint(x: centerX, y: centerY - heightFactor * 0.3),
                   controlPoint1: CGPoint(x: centerX - widthFactor * 0.4, y: centerY + heightFactor * 0.1),
                   controlPoint2: CGPoint(x: centerX - widthFactor * 0.2, y: centerY - heightFactor * 0.1))
        path.close()

        return path
    }
}

// Extension to convert NSBezierPath to CGPath
extension NSBezierPath {
    var cgPath: CGPath {
        let cgPath = CGMutablePath()
        let points = NSPointArray.allocate(capacity: 3)
        
        for i in 0..<elementCount {
            switch element(at: i, associatedPoints: points) {
            case .moveTo:
                cgPath.move(to: points[0])
            case .lineTo:
                cgPath.addLine(to: points[0])
            case .curveTo:
                cgPath.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                cgPath.closeSubpath()
            @unknown default:
                break
            }
        }
        
        points.deallocate()
        return cgPath
    }
}
#endif
