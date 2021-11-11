//
//  Sneaker+CoreDataProperties.swift
//  SneakerStats-withCoreData
//
//  Created by Kuba Florek on 05/07/2020.
//
//

import Foundation
import CoreData


extension Sneaker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sneaker> {
        return NSFetchRequest<Sneaker>(entityName: "Sneaker")
    }

    @NSManaged public var id: String?
    @NSManaged public var brand: String?
    @NSManaged public var colorway: String?
    @NSManaged public var gender: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var smallImageUrl: String?
    @NSManaged public var thumbUrl: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var retailPrice: Int16
    @NSManaged public var styleId: String?
    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var rating: Int16
    
    @NSManaged public var addedDate: Date?
    
    @NSManaged public var isWalking: Bool
    @NSManaged public var lastWalkDate: Date?
    @NSManaged public var lastWalkTime: Int16
    @NSManaged public var totalWalkTime: Int16
    @NSManaged public var totalWalks: Int16
    @NSManaged public var averageWalkTime: Double
    
    @NSManaged public var lastTimeInDailySuggestions: Date?
    @NSManaged public var showedInDailySuggestions: Int16
    @NSManaged public var averagePlace: Double
    @NSManaged public var includeInDailySuggestions: Bool
}
