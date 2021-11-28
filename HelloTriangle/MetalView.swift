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
        
        var parent: MetalView
        var commandQueue: MTLCommandQueue!
        var device: MTLDevice!
        var library: MTLLibrary!
        var renderPipelineState:MTLRenderPipelineState!

        
        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
            initMetal()
            createRenderPipelineState()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        
        func draw(in view: MTKView) {

            
            // Gives you access to drawable space in your window, useful for rendering pipeline
            guard let drawable = view.currentDrawable else { return }
            
            // Get an available command buffer from the queue
            guard let commandBuffer = commandQueue.makeCommandBuffer() else {return}
        
            // Get the MTLRenderPassDescriptor from the MTKView argument
            guard let renderPassDescriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor else { return }
            
            // Clear color from green to red
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1)

            // Make MTLRenderCommandEncoder using renderPassDescriptor
            guard let renderCommandEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            
            // TODO: Encode drawing commands
            
            // End encoding in the encoder
            renderCommandEncoder.endEncoding()
            
            // Send final rendered result to MTKView when done rendering
            commandBuffer.present(drawable)
            
            // Send encoded buffer to GPU
            commandBuffer.commit()
                        
        }
        
        // Create rendering pipeline, which loads shaders using device and outputs to the MTKView
        func createRenderPipelineState(){
            
            // Create a render pipeline descriptor
            let renderPipelineDescriptor = MTLRenderPipelineDescriptor()

            // Add shaders/functions to our pipeline
            renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
            renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
            
            // Output pixel format should match the pixel format of the metal kit view
//            renderPipelineDescriptor.colorAttachments[0].pixelFormat
            
            
            do{
                try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            }catch{
                fatalError("[!] Failed to create Render Pipeline State")
            }
            
        }
        
        func initMetal(){
            // Create link to metal device
            guard let metalDevice = MTLCreateSystemDefaultDevice() else{
                fatalError("[!] No appropriate Metal Devices found.")
            }
            
            // Create default shader library
            self.library = metalDevice.makeDefaultLibrary()
            
            // Create commande queue
            self.commandQueue = metalDevice.makeCommandQueue()
            
            // Update instance attribute to link
            self.device = metalDevice
        }
        
    }
    
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}

