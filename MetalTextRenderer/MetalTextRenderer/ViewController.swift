//
//  ViewController.swift
//  MetalTextRenderer
//
//  Created by Keith Sharp on 03/07/2021.
//

import Cocoa

import MetalKit
import ModelIO

import CoreImage.CIFilterBuiltins

class ViewController: NSViewController {
    
    var metalView: MTKView!
    var device: MTLDevice!
    
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    
    var mesh: MTKMesh!
    
    var ciContext: CIContext!
    
    var textTexture: MTLTexture!
    var samplerState: MTLSamplerState!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not get default Metal device.")
        }
        self.device = device
        
        guard let metalView = view as? MTKView else {
            fatalError("The view property of this ViewController is not an MTKView.")
        }
        self.metalView = metalView
        self.metalView.delegate = self
        self.metalView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.metalView.device = self.device
        
        initialiseModel()
        initialisePipeline()
        createSampler()
        
        ciContext = CIContext(mtlDevice: self.device)
        
        let image = createImagefromString("Hello, World!")
        let loader = MTKTextureLoader(device: self.device)
        do {
            self.textTexture = try loader.newTexture(cgImage: image, options: nil)
        } catch {
            fatalError("Failed to create text MTLTexture: \(error)")
        }
    }
    
    func createSampler() {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter             = MTLSamplerMinMagFilter.nearest
        sampler.magFilter             = MTLSamplerMinMagFilter.nearest
        sampler.mipFilter             = MTLSamplerMipFilter.nearest
        sampler.maxAnisotropy         = 1
        sampler.sAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.tAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.rAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp           = 0
        sampler.lodMaxClamp           = .greatestFiniteMagnitude
        
        samplerState = device.makeSamplerState(descriptor: sampler)
    }
    
    func createImagefromString(_ text: String) -> CGImage {
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : NSColor.red]
        let string = NSAttributedString(string: "Hello, World!", attributes: attributedStringColor)
        
        let textImageGenerator = CIFilter.attributedTextImageGenerator()
        textImageGenerator.text = string
        textImageGenerator.scaleFactor = 2.0
        
        guard let textImage = textImageGenerator.outputImage else {
            fatalError("Failed to create the text CIIMage.")
        }
        
        guard let cgImage = ciContext.createCGImage(textImage, from: textImage.extent) else {
            fatalError("Failed to get CGImage for CIImage.")
        }
        
        return cgImage
    }
    
    func initialiseModel() {
        let allocator = MTKMeshBufferAllocator(device: device)
//        let mdlMesh = MDLMesh(planeWithExtent: [0.5, 0.5, 0.5], segments: [1, 1], geometryType: .triangles, allocator: allocator)
        let mdlMesh = MDLMesh(boxWithExtent: [0.5, 0.5, 0.5], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
            
        } catch {
            fatalError("Could not convert MDLMesh to MTKMesh: \(error)")
        }
        
    }

    func initialisePipeline() {
        commandQueue = device.makeCommandQueue()
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Failed to create default Metal shader library")
        }
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state object: \(error)")
        }
    }

}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Code to handle window resize goes here
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.setFragmentTexture(textTexture, index: 0)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        guard let submesh = mesh.submeshes.first else {
            fatalError("No submesh, what should I draw?")
        }
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: 0)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }

}
