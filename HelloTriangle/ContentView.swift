//
//  ContentView.swift
//  HelloTriangle
//
//  Created by Soham Manoli on 11/26/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MetalView().frame(width: CGFloat(500), height: CGFloat(500), alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
