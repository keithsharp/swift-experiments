//
//  MapView.swift
//  MapKitTest
//
//  Created by Keith Sharp on 20/06/2021.
//

import SwiftUI
import MapKit
import GreatCircle

struct MapView: UIViewRepresentable {
    
    var route: [CLLocationCoordinate2D]
    var distance: CLLocationDistance = 600000.0 // Meters == 600km
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let routeRenderer = MKPolylineRenderer(overlay: overlay)
            routeRenderer.strokeColor = .blue
            routeRenderer.lineWidth = 5
            return routeRenderer
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let routeLine = MKPolyline(coordinates: route, count: route.count)
        mapView.addOverlay(routeLine)
        
        let currentLocation = MKPointAnnotation()
        currentLocation.title = "You are here!"
        currentLocation.coordinate = calculateCurrentLocation()
        mapView.addAnnotation(currentLocation)
        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func calculateCurrentLocation() -> CLLocationCoordinate2D {
        var cumulativeLength = 0.0
        var remainingDistance = distance
        
        if distance <= 0.0 {
            return route.first! // Crash if route is empty
        }
        
        for i in 0..<(route.count - 1) {
            let origin = CLLocation(latitude: route[i].latitude, longitude: route[i].longitude)
            let next = CLLocation(latitude: route[i + 1].latitude, longitude: route[i + 1].longitude)
            
            let segmentLength = origin.distanceTo(otherLocation: next)
            cumulativeLength += segmentLength

            if distance >= cumulativeLength {
                remainingDistance -= segmentLength
                continue
            }
            
            let bearing = origin.initialBearingTo(otherLocation: next)
            let location = origin.locationWith(bearing: bearing, distance: remainingDistance)
            
            return location.coordinate
        }
        
        return route.last! // Crash if route is empty
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
