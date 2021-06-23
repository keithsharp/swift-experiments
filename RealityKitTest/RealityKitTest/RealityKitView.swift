//
//  RealityKitView.swift
//  RealityKitTest
//
//  Created by Keith Sharp on 23/06/2021.
//

import SwiftUI
import RealityKit

struct RealityKitView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let arView = ARView()
    
        let box = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: .green, isMetallic: true)
        let entity = ModelEntity(mesh: box, materials: [material])
        
        let anchor = AnchorEntity()
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
    
        return arView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

struct RealityKitView_Previews: PreviewProvider {
    static var previews: some View {
        RealityKitView()
    }
}
