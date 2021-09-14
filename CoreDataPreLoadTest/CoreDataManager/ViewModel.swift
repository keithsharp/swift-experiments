//
//  ViewModel.swift
//  CoreDataManager
//
//  Created by Keith Sharp on 14/09/2021.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var jsonData: [JsonTrigPoint]
    
    init() {
        let decoder = JSONDecoder()
        if let url = Bundle.main.url(forResource: "trigpoints", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let trigPoints = try decoder.decode([JsonTrigPoint].self, from: data)
                self.jsonData = trigPoints
            } catch {
                print(error)
                self.jsonData = [JsonTrigPoint]()
            }
        } else {
            self.jsonData = [JsonTrigPoint]()
        }
        
        guard let url = PersistenceController.shared.container.persistentStoreDescriptions.first?.url else { return }
        print (url)
    }
}
