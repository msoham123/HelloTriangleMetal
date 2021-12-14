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


vertex VertexOutput vertexShader( constant VertexData* vertices [[buffer(0)]], uint id [[vertex_id]], constant float& time [[buffer(1)]]){
    float brightness = float((0.5 * cos(time)) + 0.5);
    float scale = float((0.5 * cos(time)) + 0.5);
    return {
            .pos =  float4(
                           vertices[id].pos.x,
                           vertices[id].pos.y,
                           vertices[id].pos.z,
                           vertices[id].pos.w
                    ),
            .color = float4(
                          vertices[id].color.x,
                          vertices[id].color.y,
                          vertices[id].color.z,
                          vertices[id].color.w
                   )

    };
}

fragment float4 fragmentShader(VertexOutput vert [[stage_in]]){
    return float4(vert.color.x, vert.color.y, vert.color.z, vert.color.w);
}


