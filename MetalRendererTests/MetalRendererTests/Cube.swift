//
//  Cube.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

import Foundation

import MetalKit
import ModelIO

import simd

class Cube {
    
    let mesh: MTKMesh
    let pipelineState: MTLRenderPipelineState
    
    var position = SIMD3<Float>(0.0, 0.0, 0.0)
    var rotation = SIMD3<Float>(0.0, 0.0, 0.0)
    var scale = SIMD3<Float>(1.0, 1.0, 1.0)
    
    var modelMatrix: matrix_float4x4 {
        return matrix_float4x4(scale: scale) * matrix_float4x4(rotation: rotation) * matrix_float4x4(translation: position)
    }
    
    init() {
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let mdlMesh = MDLMesh(boxWithExtent: [0.5, 0.5, 0.5], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        do {
            self.mesh = try MTKMesh(mesh: mdlMesh, device: Renderer.device)
        } catch {
            fatalError("Could not convert MDLMesh to MTKMesh: \(error)")
        }
        
        guard let library = Renderer.device.makeDefaultLibrary() else {
            fatalError("Failed to create default Metal shader library")
        }
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = Renderer.pixelFormat
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        
        do {
            self.pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state object: \(error)")
        }
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setRenderPipelineState(pipelineState)

        renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        guard let submesh = mesh.submeshes.first else {
            fatalError("No submesh, what should I draw?")
        }
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: 0)

        renderEncoder.endEncoding()
    }
}
