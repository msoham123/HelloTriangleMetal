//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertexShader( constant float4* vertices [[buffer(0)]] ){
    return float4(1);
}

fragment float4 fragmentShader(){
    return float4(1);
}

