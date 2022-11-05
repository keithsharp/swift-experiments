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
    
    @State private var showAddSheet = false
    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""
    
    var body: some View {
        NavigationView {
            TabView {
                List(places, id: \.self) { place in
                    Text("\(place.name ?? "Unknown")")
                    Spacer()
                    Text("\(place.tapped ? "tapped" : "not tapped")")
                }
                .tabItem { Label("List", systemImage: "list.bullet") }
                
                Map(coordinateRegion: $region, annotationItems: places) { place in
                    MapAnnotation(coordinate: place.coordinate) {
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
            .navigationTitle("Places")
            .navigationBarItems(trailing: Button("Add", action: {
                showAddSheet = true
            }))
        }
        .sheet(isPresented: $showAddSheet, content: {
            TextField("Name", text: $name)
            TextField("Latitude", text: $latitude)
                .keyboardType(.decimalPad)
            TextField("Longitude", text: $longitude)
                .keyboardType(.decimalPad)
            Button("Create") {
                let place = Place(context: moc)
                place.name = name.count > 0 ? name : "Unknown"
                place.latitude = Double(latitude) ?? 0.0
                place.longitude = Double(longitude) ?? 0.0
                do {
                    try moc.save()
                } catch {
                    print("Error creating new place: \(error.localizedDescription)")
                }
                showAddSheet = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
