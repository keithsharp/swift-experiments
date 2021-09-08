//
//  Renderer.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var pixelFormat: MTLPixelFormat!
    
    let commandQueue: MTLCommandQueue
    var model: Cube?
    
    init(view: MTKView, device: MTLDevice) {
        Renderer.device = device
        Renderer.pixelFormat = view.colorPixelFormat
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Failed to create MTLCommandQueue")
        }
        self.commandQueue = commandQueue
        
        view.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle view resize here.
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        guard let model = model else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        model.draw(renderEncoder: renderEncoder)
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
}
