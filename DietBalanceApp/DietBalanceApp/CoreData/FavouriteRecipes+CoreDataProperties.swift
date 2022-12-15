//
//  FavouriteRecipes+CoreDataProperties.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-11-01.
//
//

import Foundation
import CoreData


extension FavouriteRecipes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteRecipes> {
        return NSFetchRequest<FavouriteRecipes>(entityName: "FavouriteRecipes")
    }

    @NSManaged public var id: Int64
    @NSManaged public var foodName: String
    @NSManaged public var foodImage: String
    @NSManaged public var foodLink: String
    @NSManaged public var content: String?

}

extension FavouriteRecipes : Identifiable {

}
