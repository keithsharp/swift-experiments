//
//  Place+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Keith Sharp on 09/09/2021.
//
//

import Foundation
import CoreData
import CoreLocation

extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var tapped: Bool

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Place : Identifiable {

}
