//
//  Shaders.metal
//  MetalRendererTests
//
//  Created by Keith Sharp on 08/07/2021.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex
VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]]) {
    VertexOut vertex_out;
    vertex_out.position = vertex_in.position;
    return vertex_out;
}

fragment
float4 fragment_main(VertexOut interpolated [[stage_in]]) {
    return float4(1.0, 0.0, 0.0, 1.0);
}
