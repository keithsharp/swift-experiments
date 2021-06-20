//
//  MapView.swift
//  MapKitTest
//
//  Created by Keith Sharp on 20/06/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var route: [CLLocationCoordinate2D]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let routeRenderer = MKPolylineRenderer(overlay: overlay)
            routeRenderer.strokeColor = .red
            routeRenderer.lineWidth = 5
            return routeRenderer
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let routeLine = MKPolyline(coordinates: route, count: route.count)
        mapView.addOverlay(routeLine)
        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static let testRoute = [ CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278),
                  CLLocationCoordinate2D(latitude: 55.8642, longitude: -4.2518),
                  CLLocationCoordinate2D(latitude: 57.1497, longitude: -2.0943)]
    
    static var previews: some View {
        MapView(route: testRoute)
    }
}
