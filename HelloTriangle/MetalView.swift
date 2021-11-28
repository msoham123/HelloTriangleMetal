//
//  MetalView.swift
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//


import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MetalView>) {
        
    }
    
    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        
        let metalView = MTKView()
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            metalView.device = metalDevice
        }
        else {
            fatalError("[!] No appropriate Metal Devices found.")
        }
        
        metalView.framebufferOnly = false
        metalView.enableSetNeedsDisplay = false
        metalView.delegate = context.coordinator
        metalView.clearColor = MTLClearColorMake(0.0, 1.0, 0.0, 1.0)
        
        return metalView
    }
    
    class Coordinator : NSObject, MTKViewDelegate {
        
        var parent: MetalView!
        
        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        func draw(in view: MTKView) {

            // Gives you access to drawable space in your window, useful for rendering pipeline
            guard let drawable = view.currentDrawable else {
                return
            }
            
            // Rendering commands go here
            
        
            let renderPassDescriptor: MTLRenderPassDescriptor! = view.currentRenderPassDescriptor
            if(renderPassDescriptor == nil){
                return
            }
            
            

            
            
            // Executed every frame
            
        }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}

