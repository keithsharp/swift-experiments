//
//  ContentView.swift
//  MapKitTest
//
//  Created by Keith Sharp on 20/06/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        MapView(route: viewModel.route)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
