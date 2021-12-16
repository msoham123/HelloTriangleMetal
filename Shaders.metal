//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

#include <metal_stdlib>
#include "ShaderDefs.h"
using namespace metal;

constant float PI = 3.1415926535897932384626433832795;

struct VertexOutput{
    float4 pos [[position]];
    float4 color;
};


vertex VertexOutput vertexShader( constant VertexData* vertices [[buffer(0)]], uint id [[vertex_id]],  constant float& time [[buffer(1)]]){
//    float brightness = float((0.5 * cos(time)) + 0.5);
//    float scale = float((0.5 * cos(time)) + 0.5);
    float x = 0, y = 0;
    if(id==0){
        x = 0.871*cos(time+2.505);
        y = 0.871*cos(time-2.224)-0.171;
    }else if (id==1){
        x = 0.871*cos(time-(PI/2));
        y = 0.871*cos(time)-0.171;
    }else if (id==2){
        x = 0.871*cos(time+0.63735);
        y = 0.871*cos(time+2.224)-0.171;
//        x = 0.7;
//        y = -0.7;
    }
    return {
            .pos =  float4(
                        x,
                        y,
                        vertices[id].pos.z,
                        vertices[id].pos.w
                    ),
            .color = float4(
                        vertices[id].color.x,
                        vertices[id].color.y,
                        vertices[id].color.z,
                        vertices[id].color.z
                    )
    };
}

fragment float4 fragmentShader(VertexOutput vert [[stage_in]]){
    return float4(vert.color.x, vert.color.y, vert.color.z, vert.color.z);
}


