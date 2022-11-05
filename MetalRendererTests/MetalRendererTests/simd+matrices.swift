//
//  simd+matrices.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

import Foundation
import simd

extension float4x4 {
    
    init(fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = lhs ? far / (far - near) : far / (near - far)
        let X = SIMD4<Float>( x,  0,  0,  0)
        let Y = SIMD4<Float>( 0,  y,  0,  0)
        let Z = lhs ? SIMD4<Float>( 0,  0,  z, 1) : SIMD4<Float>( 0,  0,  z, -1)
        let W = lhs ? SIMD4<Float>( 0,  0,  z * -near,  0) : SIMD4<Float>( 0,  0,  z * near,  0)
        self = matrix_float4x4(X, Y, Z, W)
    }
    
    init(translation: SIMD3<Float>) {
        self = matrix_identity_float4x4
        self.columns.3.x = translation.x
        self.columns.3.y = translation.y
        self.columns.3.z = translation.z
    }
    
    init(scale: Float) {
        self = matrix_identity_float4x4
        self.columns.0.x = scale
        self.columns.1.y = scale
        self.columns.2.z = scale
    }
    
    init(scale: SIMD3<Float>) {
        self = matrix_identity_float4x4
        self.columns.0.x = scale.x
        self.columns.1.y = scale.y
        self.columns.2.z = scale.z
    }
    
    init(rotation: Float) {
        self = matrix_identity_float4x4
        // Rotate about X, Y, and Z using rotation
    }
    
    init(rotation: SIMD3<Float>) {
        self = matrix_identity_float4x4
        // Rotate about X, Y, and Z using rotation
    }
}
