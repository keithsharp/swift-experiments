//
//  Renderer.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

import Foundation
import MetalKit
import simd

struct Uniforms {
    var modelMatrix: matrix_float4x4
    var viewMatrix: matrix_float4x4
    var projectionMatrix: matrix_float4x4
}

class Renderer: NSObject {
    static var device: MTLDevice!
    static var pixelFormat: MTLPixelFormat!
    static var near: Float = 0.01
    static var far: Float = 100.0
    
    let commandQueue: MTLCommandQueue
    var model: Cube?
    var uniforms: Uniforms
    var camera: Camera
    
    init(view: MTKView, device: MTLDevice) {
        Renderer.device = device
        Renderer.pixelFormat = view.colorPixelFormat
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Failed to create MTLCommandQueue")
        }
        self.commandQueue = commandQueue
        
        view.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        self.camera = Camera()
        
        let aspect = Float(view.bounds.width / view.bounds.height)
        let fov = (70 / 180) * Float.pi
        let projectionMatrix = matrix_float4x4(fov: fov, near: Renderer.near, far: Renderer.far, aspect: aspect)
        
        self.uniforms = Uniforms(modelMatrix: matrix_identity_float4x4, viewMatrix: camera.viewMatrix, projectionMatrix: projectionMatrix)
    }
    
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect = Float(view.bounds.width / view.bounds.height)
        let fov = (70 / 180) * Float.pi
        uniforms.projectionMatrix = matrix_float4x4(fov: fov, near: Renderer.near, far: Renderer.far, aspect: aspect)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        guard let model = model else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        uniforms.modelMatrix = model.modelMatrix
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        model.draw(renderEncoder: renderEncoder)
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
}
