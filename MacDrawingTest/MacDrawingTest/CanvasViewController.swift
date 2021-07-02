//
//  CanvasViewController.swift
//  MacDrawingTest
//
//  Created by Keith Sharp on 02/07/2021.
//

import Cocoa

class CanvasViewController: NSViewController {

    var currentEventPosition: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func mouseDown(with event: NSEvent) {
        currentEventPosition = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = event.locationInWindow
        
        let path = NSBezierPath()
        path.move(to: currentEventPosition)
        path.line(to: point)
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.strokeColor = NSColor.red.cgColor
        line.lineWidth = 1.0
        line.lineCap = .round
        
        currentEventPosition = point
        
        view.layer?.addSublayer(line)
    }
}
