//
//  Camera.swift
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

import Foundation
import simd

class Camera {
    var position = SIMD3<Float>(0.0, 0.0, 0.0)
    var lookAt = SIMD3<Float>(0.0, 0.0, 1.0)
    
    var viewMatrix: matrix_float4x4 {
        return matrix_float4x4(rotation: lookAt) * matrix_float4x4(translation: position).inverse
    }
}
