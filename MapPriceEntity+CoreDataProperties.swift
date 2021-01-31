//
//  MapPrice+CoreDataProperties.swift
//  TicketObjC2
//
//  Created by Alexander Myskin on 24.01.2021.
//
//

import Foundation
import CoreData


extension MapPriceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPriceEntity> {
        return NSFetchRequest<MapPriceEntity>(entityName: "MapPrice")
    }

    @NSManaged public var destination: String?
    @NSManaged public var origin: String?
    @NSManaged public var departure: Date?
    @NSManaged public var returnDate: Date?
    @NSManaged public var numberOfChanges: Int16
    @NSManaged public var value: Int64
    @NSManaged public var distance: Int64

}

extension MapPriceEntity : Identifiable {

}
