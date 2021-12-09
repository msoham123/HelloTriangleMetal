//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

#include <metal_stdlib>
#include "ShaderDefs.h"
using namespace metal;


struct VertexOutput{
    float4 pos [[position]];
    float4 color;
};


vertex VertexOutput vertexShader( constant VertexData* vertices [[buffer(0)]], uint id [[vertex_id]], constant Uniforms& uniforms [[buffer(1)]]){
    return {
            .pos =  vertices[id].pos,
            .color = float4(
                          uniforms.brightness * vertices[id].color.x,
                          uniforms.brightness * vertices[id].color.y,
                          uniforms.brightness * vertices[id].color.z,
                          uniforms.brightness * vertices[id].color.w
                   )

    };
}

fragment float4 fragmentShader(VertexOutput vert [[stage_in]]){
    return float4(vert.color.x, vert.color.y, vert.color.z, vert.color.w);
}


