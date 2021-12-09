//
//  ShaderDefs.h
//  HelloTriangle
//
//  Created by Soham Manoli on 12/8/21.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#include <simd/simd.h>

struct Vertex{
    simd_float4 color;
    simd_float4 pos;
};

struct FragmentUniforms{
    float brightness;
};


#endif /* ShaderDefs_h */
