//
//  JsonTrigPoint.swift
//  CoreDataManager
//
//  Created by Keith Sharp on 14/09/2021.
//

import Foundation

struct JsonTrigPoint: Codable, Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double
}
