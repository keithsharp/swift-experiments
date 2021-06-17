//
//  ViewModel.swift
//  HealthKitTest
//
//  Created by Keith Sharp on 17/06/2021.
//

import Foundation
import HealthKit

class ViewModel: ObservableObject {
    
    @Published var healthKitAvailable: Bool = false
    @Published var model = [Model]()
    
    private var healthStore: HKHealthStore? = nil
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            requestHealthKitAccess()
        }
    }
}

// MARK: - HealthKit Interactions
extension ViewModel {
    func requestHealthKitAccess() {
        guard let healthStore = healthStore else {
            print("requestHealthKitAccess: ViewModel.healthStore is nil.")
            return
        }
        
        let activityTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
        
        healthStore.requestAuthorization(toShare: nil, read: activityTypes) { success, error in
            if success {
                print("requestHealthKitAccess: Got access to HealthKit")
                DispatchQueue.main.async {
                    self.healthKitAvailable = true
                }
            } else {
                print("requestHealthKitAccess: Not got access to HealthKit: \(error?.localizedDescription ?? "no detail")")
                DispatchQueue.main.async {
                    self.healthKitAvailable = false
                }
            }
        }
    }
    
    func getDistanceWalkedRun() {
        guard let healthStore = healthStore else {
            print("getDistanceWalkedRun: ViewModel.healthStore is nil.")
            return
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("getDistanceWalkedRun: unable to create distanceWalkingRunning quantity type.")
        }
        
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: Date(), intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    print("getDistanceWalkedRun: couldn't access the database because the device is locked.")
                    return
                default:
                    print("getDistanceWalkedRun: couldn't access the database: \(error.localizedDescription)")
                    return
                }
            }
            
            guard let statsCollection = results else {
                print("getDistanceWalkedRun: got no results, strange.")
                return
            }
            
            for stat in statsCollection.statistics() {
                let quantity = stat.sumQuantity()
                if let distance = quantity?.doubleValue(for: HKUnit.mile()) {
                    let entry = Model(date: stat.startDate, distance: distance)
                    DispatchQueue.main.async {
                        self.model.append(entry)
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
}
