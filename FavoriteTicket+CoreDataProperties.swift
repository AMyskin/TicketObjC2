//
//  FavoriteTicket+CoreDataProperties.swift
//  TicketObjC2
//
//  Created by Alexander Myskin on 24.01.2021.
//
//

import Foundation
import CoreData


extension FavoriteTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTicket> {
        return NSFetchRequest<FavoriteTicket>(entityName: "FavoriteTicket")
    }

    @NSManaged public var flightNumber: Int16
    @NSManaged public var price: Int64
    @NSManaged public var to: String?
    @NSManaged public var from: String?
    @NSManaged public var airline: String?
    @NSManaged public var returnData: Date?
    @NSManaged public var expires: Date?
    @NSManaged public var departure: Date?
    @NSManaged public var created: Date?

}

extension FavoriteTicket : Identifiable {

}
