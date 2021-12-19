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


vertex VertexOutput vertexShader( constant VertexData* vertices [[buffer(0)]], uint id [[vertex_id]],  constant float& time [[buffer(1)]]){
    float brightness = float((0.5 * cos(time)) + 0.5);
    float scale = float((0.5 * cos(time)) + 0.5);
    return {
            .pos =  float4(
                        scale * vertices[id].pos.x,
                        scale * vertices[id].pos.y,
                        scale * vertices[id].pos.z,
                        vertices[id].pos.w
                    ),
            .color = float4(
                        brightness * vertices[id].color.x,
                        brightness * vertices[id].color.y,
                        brightness * vertices[id].color.z,
                        vertices[id].color.z
                    )
    };
}

fragment float4 fragmentShader(VertexOutput vert [[stage_in]]){
    return float4(vert.color.x, vert.color.y, vert.color.z, vert.color.z);
}
