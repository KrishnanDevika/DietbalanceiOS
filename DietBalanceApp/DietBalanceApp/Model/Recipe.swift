//
//  Recipe.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-05.
//

import Foundation

enum Section: CaseIterable{
    case main
}

struct Recipes : Codable{
    var searchResults : [Recipe]
}

struct Recipe : Codable, Hashable{

    var results : [RecipeDetail]
}

struct RecipeDetail : Codable, Hashable{
    var id : Int64?
    var name : String
    var foodImage : String?
    var recipeLink : String?
    var content : String?


    enum CodingKeys: String, CodingKey{
        case id
        case name
        case foodImage = "image"
        case recipeLink = "link"
        case content
    }
}

struct HealthyRecipe : Codable,Hashable{
    
    var title : String
    var image : String?
    var calories : Int
    var protein : String
    var fat : String
    var carbs : String
    
    
}
