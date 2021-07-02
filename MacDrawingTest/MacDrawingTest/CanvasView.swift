//
//  CanvasView.swift
//  MacDrawingTest
//
//  Created by Keith Sharp on 02/07/2021.
//

import Cocoa

struct Line {
    var colour: NSColor
    var points: [CGPoint]
    
    init(points: [CGPoint], colour: NSColor = .white) {
        self.points = points
        self.colour = colour
    }
}

class CanvasView: NSView {
    
    var lines = [Line]()
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        for line in lines {
            for (i, point) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
                context.setLineWidth(1.0)
                context.setStrokeColor(line.colour.cgColor)
            }
            context.setLineCap(.round)
            context.strokePath()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        lines.append(Line(points: [CGPoint](), colour: .red))
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = event.locationInWindow
        
        guard var line = lines.popLast() else { return }
        line.points.append(point)
        lines.append(line)
        
        setNeedsDisplay(self.frame)
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
}
