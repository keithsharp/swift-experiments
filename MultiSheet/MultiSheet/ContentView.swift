//
//  ContentView.swift
//  MultiSheet
//
//  Created by Keith Sharp on 08/09/2021.
//

import SwiftUI

enum SheetTypes {
    case name(name: String)
    case age(age: Int)
    case country(country: String)
}

extension SheetTypes: Identifiable {
    var id: Int {
        switch self {
        case .name:
            return 1
        case .age:
            return 2
        case .country:
            return 3
        }
    }
}

struct NameView: View {
    let name: String
    
    var body: some View {
        Text("Name: \(name)")
    }
}

struct AgeView: View {
    let age: Int
    
    var body: some View {
        Text("Age: \(age)")
    }
}

struct CountryView: View {
    let country: String
    
    var body: some View {
        Text("Country: \(country)")
    }
}

struct ContentView: View {
    @State private var selectedSheet: SheetTypes?
    
    @State private var name: String = ""
    @State private var age: Int = 21
    @State private var country: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Name", text: $name)
                    Button("Show Name Sheet") {
                        selectedSheet = .name(name: name)
                    }
                }
                .padding()
                
                HStack {
                    Stepper(value: $age, in: 0...130) {
                        Text("Age: \(age)")
                    }
                    Button("Show Age Sheet") {
                        selectedSheet = .age(age: age)
                    }
                }
                .padding()
                
                HStack {
                    TextField("Country", text: $country)
                    Button("Show Country Sheet") {
                        selectedSheet = .country(country: country)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Show Sheets")
            .sheet(item: $selectedSheet) { item in
                switch item {
                case let .name(name):
                    NameView(name: name)
                case let .age(age):
                    AgeView(age: age)
                case let .country(country):
                    CountryView(country: country)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
