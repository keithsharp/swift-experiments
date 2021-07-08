//
//  MetalViewController.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 07/07/2021.
//

import Cocoa
import MetalKit

class MetalViewController: NSViewController {
    
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let metalView = view as? MTKView else {
            fatalError("Could not get view as an MTKView.")
        }
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not get system default GPU.")
        }
        
        metalView.device = device
        
        renderer = Renderer(view: metalView, device: device)
        metalView.delegate = renderer
        
        renderer.model = Cube()
    }
    
}
