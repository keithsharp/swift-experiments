//
//  ContentView.swift
//  HealthKitTest
//
//  Created by Keith Sharp on 17/06/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Button {
                viewModel.getDistanceWalkedRun()
            } label: {
                Text("Get distances")
            }
            .disabled(!viewModel.healthKitAvailable)
        
            List {
                ForEach(viewModel.model) { item in
                    Text(item.summary)
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
