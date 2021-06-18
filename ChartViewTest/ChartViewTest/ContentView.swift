//
//  ContentView.swift
//  ChartViewTest
//
//  Created by Keith Sharp on 17/06/2021.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    private var viewModel = ViewModel()
    
    @State private var tabIndex = 0
    
    var body: some View {
        
        TabView(selection: $tabIndex) {
            GeometryReader { geo in
                BarChartView(data: viewModel.dateItemsChartData,
                             title: "Test Bar Chart",
                             form: geo.size,
                             dropShadow: false,
                             cornerImage: nil)
            }
            .tabItem { Label("Bar", systemImage: "chart.bar.fill") }
            .tag(0)
            
            GeometryReader { geo in
                LineChartView(data: viewModel.itemsChartData.onlyPoints(),
                              title: "Test Line Chart",
                              form: geo.size,
                              dropShadow: false)
            }
            .tabItem { Label("Line", systemImage: "chart.bar.xaxis") }
            .tag(1)
            
            GeometryReader { geo in
                PieChartView(data: viewModel.itemsChartData.onlyPoints(),
                             title: "Test Pie Chart",
                             form: geo.size,
                             dropShadow: false)
            }
            .tabItem { Label("Pie", systemImage: "chart.pie.fill") }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
