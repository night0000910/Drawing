//
//  Picture.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/22.
//

import UIKit

class Picture: UIView {
    
    var picture:UIImage? = nil
    var currentPoint:CGPoint? = nil
    var newPoint:CGPoint? = nil
    var color = UIColor(hue:1.0, saturation:1.0, brightness:1.0, alpha:1.0)
    
    var shape = Picture.Shape.line
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect:CGRect) {
        
        if let picture = self.picture {
            
            picture.draw(at:CGPoint(x:0, y:0))
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            self.currentPoint = touch.location(in:self)
            
        }
        
        switch self.shape {
        
        case .line:
            break
        
        case .rectangle:
            
            guard let currentPoint = self.currentPoint else {
                
                return
                
            }
            
            self.drawRectangle(currentPoint:currentPoint)
        
        case .heart:
            
            guard let currentPoint = self.currentPoint else {
                
                return
                
            }
            
            self.drawHeart(currentPoint:currentPoint)
        
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            
            return
            
        }
        
        self.newPoint = touch.location(in:self)
        
        guard let currentPoint = self.currentPoint else {
            
            return
            
        }
        
        guard let newPoint = self.newPoint else {
            
            return
            
        }
        
        switch shape {
        
        case .line:
            drawPicture(currentPoint:currentPoint, newPoint:newPoint)
            self.currentPoint = self.newPoint
        
        case .rectangle:
            break
        
        case .heart:
            break
        
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            
            return
            
        }
        
        self.newPoint = touch.location(in:self)
        
        guard let currentPoint = self.currentPoint else {
            
            return
            
        }
        
        guard let newPoint = self.newPoint else {
            
            return
            
        }
        
        switch shape {
        
        case .line:
            drawPicture(currentPoint:currentPoint, newPoint:newPoint)
            self.currentPoint = self.newPoint
        
        case .rectangle:
            break
        
        case .heart:
            break
        
        }
        
    }
    
    func drawPicture(currentPoint:CGPoint, newPoint:CGPoint) {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.picture?.draw(at:CGPoint(x:0, y:0))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return
            
        }
        
        self.color.setStroke()
        
        context.move(to:currentPoint)
        context.addLine(to:newPoint)
        context.strokePath()
        
        self.picture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
        
    }
    
    func drawRectangle(currentPoint:CGPoint) {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.picture?.draw(at:CGPoint(x:0, y:0))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return
            
        }
        
        self.color.setStroke()
        
        context.translateBy(x:currentPoint.x-20, y:currentPoint.y-20)
        context.scaleBy(x:40, y:40)
        context.move(to:CGPoint(x:0, y:0))
        context.addLine(to:CGPoint(x:1, y:0))
        context.addLine(to:CGPoint(x:1, y:1))
        context.addLine(to:CGPoint(x:0, y:1))
        context.addLine(to:CGPoint(x:0, y:0))
        context.strokePath()
        
        self.picture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
        
    }
    
    func drawHeart(currentPoint:CGPoint) {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.picture?.draw(at:CGPoint(x:0, y:0))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return
            
        }
        
        self.color.setStroke()
        
        context.translateBy(x:currentPoint.x, y:currentPoint.y-37.5)
        context.scaleBy(x:75, y:75)
        context.move(to:CGPoint(x:0, y:0.25))
        context.addCurve(to:CGPoint(x:0.5, y:0.3), control1:CGPoint(x:0.1, y:0), control2:CGPoint(x:0.5, y:0))
        context.addCurve(to:CGPoint(x:0, y:0.9), control1:CGPoint(x:0.5, y:0.75), control2:CGPoint(x:0, y:0.9))
        context.addCurve(to:CGPoint(x:-0.5, y:0.3), control1:CGPoint(x:0, y:0.9), control2:CGPoint(x:-0.5, y:0.75))
        context.addCurve(to:CGPoint(x:0, y:0.25), control1:CGPoint(x:-0.5, y:0), control2:CGPoint(x:-0.1, y:0))
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        self.picture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
        
    }
    
    enum Shape {
        
        case line
        
        case rectangle
        
        case heart
        
    }

}
