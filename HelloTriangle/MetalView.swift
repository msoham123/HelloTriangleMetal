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
            metalView.preferredFramesPerSecond = 60
            
            return metalView
    }
    
    class Coordinator : NSObject, MTKViewDelegate {
        
        var parent: MetalView
        var commandQueue: MTLCommandQueue!
        var device: MTLDevice!
        var library: MTLLibrary!
        var renderPipelineState:MTLRenderPipelineState!
        
        
        // Buffer
        var vertexBuffer: MTLBuffer!
        var vertexUniformsBuffer: MTLBuffer!
        

        // Current time in units of seconds
        var time: Float = 0
        
        // Target FPS
        let FPS: Int = 60
    
        // Semaphore which prevents uniform buffer from cpu with overlapping rendering by GPU
//        let gpuLock = DispatchSemaphore(value: 1)

        
        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
            initMetal()
            createRenderPipelineState()
            createBuffers()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        
        func draw(in view: MTKView) {
            
            // Wait for synchronization (greater than zero value)
//            gpuLock.wait()
            
            // Gives you access to drawable space in your window, useful for rendering pipeline
            guard let drawable = view.currentDrawable else { return }
            
            // Get an available command buffer from the queue
            guard let commandBuffer = commandQueue.makeCommandBuffer() else {return}
        
            // Get the MTLRenderPassDescriptor from the MTKView argument
            guard let renderPassDescriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor else { return }
            
            // Clear color from green to red
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)

            // Make MTLRenderCommandEncoder using renderPassDescriptor
            guard let renderCommandEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            
            // Set the render pipeline state
            renderCommandEncoder.setRenderPipelineState(self.renderPipelineState)
                        
            // Set the vertex data buffer for the vertex shader to use
            renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
            
            // Set the uniform buffer for the fragment shader to use
//            renderCommandEncoder.setVertexBuffer(self.vertexUniformsBuffer, offset: 0, index: 1)
            
            // Update the time by passing timeDifference to vertex shader
            renderCommandEncoder.setVertexBytes(&self.time, length: MemoryLayout<Float>.stride, index: 1)
            
            // Decide what kind of primitive to draw
            renderCommandEncoder.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: 3)
                        
            // End encoding tttin the encoder
            renderCommandEncoder.endEncoding()
            
            // Send final rendered result to MTKView when done rendering
            commandBuffer.present(drawable)
            
            // Call when GPU is done drawing
//            commandBuffer.addCompletedHandler { _ in
//                // Increment the semaphore value by one
////                self.gpuLock.signal()
//            }
            
            // Send encoded buffer to GPU
            commandBuffer.commit()
            
            // Increment current time by the interval
            self.time += 1/Float(FPS)
        }
        
        // Create rendering pipeline, which loads shaders using device and outputs to the MTKView
        func createRenderPipelineState(){
            
            // Create a render pipeline descriptor
            let renderPipelineDescriptor = MTLRenderPipelineDescriptor()

            // Add shaders/functions to our pipeline
            renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
            renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
            
            // Output pixel format should match the pixel format of the metal kit view
            renderPipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.bgra8Unorm
            
            do{
                try self.renderPipelineState = device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
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
        
        func createBuffers(){
            
            // Create our vertex data which represents triangle
            // FORMATS: POS [X,Y,D,P], COLOR [R, G, B, A] 
            
//            let vertices = [
//
//                // Vertices Positions
//                simd_float4(-0.7, -0.7, 1, 1),
//                simd_float4(0, 0.7, 1, 1),
//                simd_float4(0.7, -0.7, 1, 1),
//
//                // Vertices Colors
//                simd_float4(1, 0, 0, 1),
//                simd_float4(0, 1, 0, 1),
//                simd_float4(0, 0, 1, 1)
//            ]
            
            let vertices = [
                
                VertexData(
                    pos: simd_float4(-0.7, -0.7, 1, 1),
                    color: simd_float4(1, 0, 0, 1)
                ),
                VertexData(
                    pos: simd_float4(0, 0.7, 1, 1),
                    color: simd_float4(0, 1, 0, 1)
                ),
                VertexData(
                    pos: simd_float4(0.7, -0.7, 1, 1),
                    color: simd_float4(0, 0, 1, 1)
                )
                
            ]
            
            
            // Copy vertex data to vertex buffer
            self.vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<VertexData>.stride, options: [])!
            
            
            // Create  uniform buffer and fill it with an initial brightness of 1.0
            var vertexUniforms = Uniforms(brightness: 1, scale: 1)
            self.vertexUniformsBuffer = device.makeBuffer(bytes: &vertexUniforms, length: MemoryLayout<Uniforms>.stride, options:[])!
        }
        
//        func update(timeDifference: CFTimeInterval, encoder: MTLRenderCommandEncoder, index: Int){
            // Create pointer that points to Uniforms object from buffer
//            let uniformPtr = self.vertexUniformsBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
            
            // Create speed variable to change fade speed
//            let speed = 2.0
            
            // Use current time to change value of brightness
//            uniformPtr.pointee.brightness = Float((0.5 * cos(speed * self.currentTime)) + 0.5)
            
            // Use current time to change value of scale
//            uniformPtr.pointee.scale = Float((0.5 * cos(speed * self.currentTime)) + 0.5)
            
//            encoder.setVertexBytes(&timeDifference, length: 0, index: index)
//
//            // Increment current time by the interval
//            self.currentTime += timeDifference
//        }
        
    }
    
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}

