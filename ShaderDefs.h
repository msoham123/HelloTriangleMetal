//
//  ShaderDefs.h
//  HelloTriangle
//
//  Created by Soham Manoli on 12/8/21.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#include <simd/simd.h>

struct VertexData{
    simd_float4 pos;
    simd_float4 color;
};

struct FragmentUniforms{
    float brightness;
};


#endif /* ShaderDefs_h */
