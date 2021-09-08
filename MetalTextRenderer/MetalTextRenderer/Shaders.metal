//
//  Shaders.metal
//  MetalTextRenderer
//
//  Created by Keith Sharp on 03/07/2021.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texcoord;
};

vertex
VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]]) {
    VertexOut vertex_out;
    vertex_out.position = vertex_in.position;
    vertex_out.texcoord = vertex_in.texcoord;
    return vertex_out;
}

fragment
float4 fragment_main(VertexOut interpolated [[stage_in]],
                     texture2d<float>  tex2D     [[ texture(0) ]],
                     sampler           sampler2D [[ sampler(0) ]]) {
    float4 color = tex2D.sample(sampler2D, interpolated.texcoord);
    return color;
}
