//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex{
    float4 color;
    float4 pos [[position]];
};


vertex Vertex vertexShader( constant float4* vertices [[buffer(0)]], uint id [[vertex_id]]){
    return {
            .color =  float4(vertices[id+3].xyzw),
            .pos = float4(vertices[id].xyzw),

    };
}

fragment float4 fragmentShader(Vertex vert [[stage_in]], constant FragmentUniforms& uniforms [[buffer(0)]] ){
    return float4(uniforms.brightness * vert.color.x, uniforms.brightness * vert.color.y, uniforms.brightness * vert.color.z, vert.color.w);
}


