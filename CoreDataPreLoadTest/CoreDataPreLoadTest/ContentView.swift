//
//  ContentView.swift
//  CoreDataPreLoadTest
//
//  Created by Keith Sharp on 14/09/2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TrigPoint.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TrigPoint.name, ascending: true)]) var trigPoints: FetchedResults<TrigPoint>
        
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.8, longitude: -4.2), span: MKCoordinateSpan(latitudeDelta: 11.5, longitudeDelta: 12.22))
        
    
    var body: some View {
        NavigationView {
            TabView {
                Map(coordinateRegion: $region, annotationItems: trigPoints) { point in
                    MapAnnotation(coordinate: point.coordinate) {
                        Circle()
                            .strokeBorder(Color.red, lineWidth: 4)
                            .frame(width: 10, height: 10)
                    }
                }
                .tabItem { Label("Map", systemImage: "globe") }
                
                List(trigPoints, id: \.self) { point in
                    Text("\(point.name)")
                }
                .tabItem { Label("List", systemImage: "list.bullet") }
            }
            .navigationTitle("Trig Points")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
