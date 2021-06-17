//
//  Model.swift
//  HealthKitTest
//
//  Created by Keith Sharp on 17/06/2021.
//

import Foundation

struct Model: Identifiable, Hashable {
    let id = UUID()
    
    let date: Date
    let distance: Double
    
    var summary: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return "On \(formatter.string(from: date)) you did \(distance) miles"
    }
}
