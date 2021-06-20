//
//  ViewModel.swift
//  MapKitTest
//
//  Created by Keith Sharp on 20/06/2021.
//

import Foundation
import CoreLocation

class ViewModel: ObservableObject {
    @Published var route = [CLLocationCoordinate2D]()
    @Published var distance = 0.0
    
    init() {
        let london = CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278)
        let glasgow = CLLocationCoordinate2D(latitude: 55.8642, longitude: -4.2518)
        let aberdeen = CLLocationCoordinate2D(latitude: 57.1497, longitude: -2.0943)
        
        route.append(london)
        route.append(glasgow)
        route.append(aberdeen)
    }
}
