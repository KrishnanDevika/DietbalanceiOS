//
//  Foods+CoreDataProperties.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-26.
//
//

import Foundation
import CoreData


extension Foods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foods> {
        return NSFetchRequest<Foods>(entityName: "Foods")
    }

    @NSManaged public var title: String
    @NSManaged public var image: String
    @NSManaged public var calories: Int64
    @NSManaged public var protein: String
    @NSManaged public var fat: String
    @NSManaged public var carbs: String

}

extension Foods : Identifiable {

}
