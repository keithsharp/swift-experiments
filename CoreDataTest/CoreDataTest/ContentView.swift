//
//  ContentView.swift
//  CoreDataTest
//
//  Created by Keith Sharp on 09/09/2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Place.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Place.name, ascending: true)]) var places: FetchedResults<Place>
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.8, longitude: -4.2), span: MKCoordinateSpan(latitudeDelta: 11.5, longitudeDelta: 12.22))
    
    var body: some View {
        TabView {
            List(places, id: \.self) { place in
                Text("\(place.name ?? "Unknown")")
                Spacer()
                Text("\(place.tapped ? "tapped" : "not tapped")")
            }
            .tabItem { Label("List", systemImage: "list.bullet") }
            
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                    Circle()
                        .strokeBorder(place.tapped ? Color.green : Color.gray, lineWidth: 4)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            print("Tapped \(place.name ?? "Unknown")")
                            place.tapped.toggle()
                            if moc.hasChanges {
                                do {
                                    try moc.save()
                                } catch {
                                    print("Error saving change to \(place.name ?? "Unknown"): \(error.localizedDescription)")
                                }
                            }
                        }
                }
            }
            .tabItem { Label("Map", systemImage: "globe") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
