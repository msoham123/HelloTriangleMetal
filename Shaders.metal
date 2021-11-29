//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex{
    float2 color;
    float4 pos [[position]];
};

vertex Vertex vertexShader( constant float4* vertices [[buffer(0)]], uint id [[vertex_id]]){
    return {
            .color = vertices[id].zw,
            .pos =  float4(vertices[id].xy, 1.0, 1.0),
    };
}

fragment float4 fragmentShader(Vertex vert [[stage_in]]){
    return float4(vert.color.x/255, vert.color.y/255, 0.5, 1.0);
}

