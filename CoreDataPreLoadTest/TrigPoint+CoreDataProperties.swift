//
//  TrigPoint+CoreDataProperties.swift
//  CoreDataPreLoadTest
//
//  Created by Keith Sharp on 14/09/2021.
//
//

import Foundation
import CoreData
import CoreLocation

extension TrigPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrigPoint> {
        return NSFetchRequest<TrigPoint>(entityName: "TrigPoint")
    }

    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var elevation: Double
    @NSManaged public var id: String

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension TrigPoint : Identifiable {

}
