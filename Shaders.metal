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
    float4 color;
    float4 pos [[position]];
};


vertex VertexOutput vertexShader( constant VertexData* vertices [[buffer(0)]], uint id [[vertex_id]]){
    return {
            .color =  vertices[id].color,
            .pos = vertices[id].pos,

    };
}

fragment float4 fragmentShader(VertexOutput vert [[stage_in]], constant FragmentUniforms& uniforms [[buffer(0)]] ){
    return float4(uniforms.brightness * vert.color.x, uniforms.brightness * vert.color.y, uniforms.brightness * vert.color.z, vert.color.w);
}


