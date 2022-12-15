//
//  DetailViewController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-07.
//

import UIKit
import WebKit
import CoreData
import CoreSpotlight


class DetailViewController: UIViewController {
    
    //MARK: - Properties
    var recipe: RecipeDetail?
    var recipeList: RecipeList!
    var coreDataStack : CoreDataStack!
    var myFavouriteRecipe = [FavouriteRecipes]()


    //MARK: - Outlets
    @IBOutlet weak var recipeName: UILabel!

    @IBOutlet weak var webView: WKWebView!
    
    
    //MARK: - Actions
    
    @IBAction func addToFavorites(_ sender: Any) {
    
        if let recipe = recipe{
            //Check if favorite  recipe array list is empty add the recipe to your favourites
            if myFavouriteRecipe.isEmpty{
                let newRecipe =  FavouriteRecipes(context: self.coreDataStack.managedContext)

                if let image = recipe.foodImage{
                    newRecipe.foodImage = image
                }
                newRecipe.foodName = recipe.name
                newRecipe.content = recipe.content
                if let link = recipe.recipeLink{
                newRecipe.foodLink = link
                }
                if let id = recipe.id{
                newRecipe.id = id
                }
                
                myFavouriteRecipe.append(newRecipe)
                self.coreDataStack.saveContext()
                showAlert(withTitle:  "🍱Added", withMessage: "\(newRecipe.foodName) has been added to your Favourites!")
            }
            //Else check if that recipe is already exist in your favourites
            else{
               var count = 0
                for myRecipe in myFavouriteRecipe {
                    if myRecipe.id != recipe.id{
                        count += 1
                    }
                }
                if count == myFavouriteRecipe.count{
                    let newRecipe =  FavouriteRecipes(context: self.coreDataStack.managedContext)

                    if let image = recipe.foodImage{
                        newRecipe.foodImage = image
                    }
                    if let link = recipe.recipeLink{
                    newRecipe.foodLink = link
                    }
                    newRecipe.foodName = recipe.name
                    newRecipe.content = recipe.content
                    if let id = recipe.id{
                    newRecipe.id = id
                    }
            
                   myFavouriteRecipe.append(newRecipe)
                   self.coreDataStack.saveContext()
          
                    showAlert(withTitle:  "🍱Added", withMessage: "\(newRecipe.foodName) has been added to your Favourites!")
                
                   }else{
                       
                       showAlert(withTitle: "The Recipe \(recipe.name) is already in your Favouirtes List.", withMessage: "" )
                   }
            }
            
            addToSpotlight(recipeToAdd : recipe)
        }
    }
    //MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //Populate this page with recipe passed from Search Page
        if let recipe = recipe {
           
            recipeName.text = recipe.name
            guard let url = URL(string: recipe.recipeLink ?? "") else{
            showAlert(withTitle: "No More Information available", withMessage: "This recipe does not contain more information")
                return
            }
            //ueing the string url load the web page
            webView.load(URLRequest(url: url))
        }
     fetchMyCollections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyCollections()
    }
    
    //MARK: - Fetch Data from Core Data
    func fetchMyCollections(){
        let fetchRequest: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        do {
            //Fetch favourte recipe from coredata and populate them to myFavourite recipe array.
            myFavouriteRecipe = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch {
            print("Problem fetching Recipes\(error)")
        }
    }
    
    //MARK: - Alert Methods
     func showAlert(withTitle title: String, withMessage message: String){
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default){
             [weak self] _ in
             self?.navigationController?.popViewController(animated: true)
         }
         alert.addAction(okAction)
         
         present(alert,animated: true)
     }
    
    //MARK: - Core Spotlight
    func addToSpotlight(recipeToAdd : RecipeDetail)
    {
        //Adding product to spotlight search
         var ItemAttributeSet:CSSearchableItemAttributeSet{
             let attributeSet = CSSearchableItemAttributeSet(contentType: .text)

             //Set the details of the application to be displayed in spotlight search
             attributeSet.contentDescription = "Recipe information for \(recipeToAdd.name)"

             attributeSet.title = "Diet Balance Application"
             attributeSet.keywords = [
                " \(recipeToAdd.name)"]

             return attributeSet
         }

        //Add the recipe to the spolight using recipe id
        if let id = recipeToAdd.id{
            let item = CSSearchableItem(uniqueIdentifier: "\(id)", domainIdentifier: nil, attributeSet: ItemAttributeSet)

             CSSearchableIndex.default().indexSearchableItems([item]){
                 error in
                 if let indexError = error {
                     print("We have an indexing error - \(indexError.localizedDescription)")
                 }else {
                     print(" \(recipeToAdd.name)has been indexed")
                 }
              }
        }
        
    }

}
