//
//  ContentView.swift
//  CoreDataManager
//
//  Created by Keith Sharp on 14/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
            VStack {
                Text("Loaded \(viewModel.jsonData.count) Trig Points from JSON")
                    .padding()
                
                List {
                    ForEach(viewModel.jsonData) { point in
                        Text("\(point.name)")
                    }
                }
                
                Button(action: {
                    saveToCoreData()
                }, label: {
                    Text("Save to Core Data")
                })
                .padding()
            }
    }
    
    func saveToCoreData() {
        for point in viewModel.jsonData {
            print("Create trig point \(point.name) in Core Data")
            let trigPoint = TrigPoint(context: moc)
            trigPoint.id = point.id
            trigPoint.name = point.name
            trigPoint.latitude = point.latitude
            trigPoint.longitude = point.longitude
            trigPoint.elevation = point.elevation
        }
        if moc.hasChanges {
            do {
                print("Saving Trig Points to Core Data")
                try moc.save()
            } catch {
                print("Failed to save changes to Core Data: \(error.localizedDescription)")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
