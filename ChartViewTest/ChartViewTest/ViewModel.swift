//
//  ViewModel.swift
//  ChartViewTest
//
//  Created by Keith Sharp on 18/06/2021.
//

import Foundation
import SwiftUICharts

class ViewModel: ObservableObject {
    @Published var items: [Item]
    @Published var dateItems: [DateItem]
    
    private let count = 20
    
    init() {
        self.items = [Item]()
        self.dateItems = [DateItem]()
        
        for i in 1...count {
            let item = Item(label: String(i), value: Int.random(in: 1...10))
            items.append(item)
        }
        
        let now = Date()
        for i in 1...count {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: now)!
            let item = DateItem(date: date, value: Int.random(in: 1...10))
            dateItems.append(item)
        }
    }
}

// MARK: - ChartData for ChartView
extension ViewModel {
    var dateItemsChartData: ChartData {
        let sortedArray = dateItems.sorted { $0.date < $1.date }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let values = sortedArray.map { ("\(formatter.string(from: $0.date))", $0.value) }
        return ChartData(values: values)
    }
    
    var itemsChartData: ChartData {
        let values = items.map { ($0.label, $0.value) }
        return ChartData(values: values)
    }
}
