//
//  Shaders.metal
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float4x4  modelMatrix;
    float4x4  viewMatrix;
    float4x4  projectionMatrix;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex
VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]],
                      constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut vertex_out;
    vertex_out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
//    vertex_out.position = uniforms.projectionMatrix * vertex_in.position;
    return vertex_out;
}

fragment
float4 fragment_main(VertexOut interpolated [[stage_in]]) {
//    return float4(1.0, 0.0, 0.0, 1.0);
    return interpolated.position;
}
