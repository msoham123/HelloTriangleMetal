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
    float4 current = *(vertices+id);
    Vertex vert;
    vert.color = float2(current.z, current.w);
    vert.pos = float4(current.x, current.y, 1, 0.5);
    return vert;
}

fragment float4 fragmentShader(){
    return float4(1);
}

