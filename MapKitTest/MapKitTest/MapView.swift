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
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LocationAnnotation else { return  nil }

            var view = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(LocationAnnotationView.self), for: annotation) as? LocationAnnotationView
            
            if view == nil {
                view = LocationAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(LocationAnnotationView.self))
            }
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation as? LocationAnnotation else {
                print("Wrong type of annotation!")
                return
            }
            print("Tapped annotation with ID: \(annotation.id)")
        }
    }
    
    class LocationAnnotation: NSObject, MKAnnotation {
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = "Yes you really are."
        }
    }
    
    class LocationAnnotationView: MKMarkerAnnotationView {

        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

            titleVisibility = .hidden
            canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView = btn
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForDisplay() {
            super.prepareForDisplay()
            
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let routeLine = MKPolyline(coordinates: route, count: route.count)
        mapView.addOverlay(routeLine)
        
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(LocationAnnotationView.self))
        let annotation = LocationAnnotation(coordinate: calculateCurrentLocation(), title: "You are here!")
        mapView.addAnnotation(annotation)
        
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
