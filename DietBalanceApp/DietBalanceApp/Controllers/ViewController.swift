//
//  ViewController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-09-29.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    
    var recipeList: RecipeList!
    var recipes = [Recipe]()
    var coreDataStack : CoreDataStack!
    var food = [RecipeDetail]()
    var fetchedRecipe = [RecipeDetail]()
  
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    
    //MARK: - Actions
    @IBAction func ClearSearchResults(_ sender: Any) {
        recipes = []
        food = []
        fetchedRecipe = []
        recipeSearchBar.text = nil
        //Clear the fetched recipe array and call the snapshot
        createSnapShot()
    }
    //MARK: - DatSource
    private lazy var dataSource = UITableViewDiffableDataSource <Section, RecipeDetail>(tableView: tableView){
        tableView, indexPath, recipe in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.recipeName.text = recipe.name
        
        if let recipeImage = recipe.foodImage{
        self.fetchImage(for: recipeImage, in: cell)
        }
        
        return cell
    }
    
    //MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        recipeSearchBar.delegate = self
        recipeSearchBar.layer.cornerRadius = 15
    }
    


    //MARK: - Snapshot methods
    //TableView using Diffable datasource
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RecipeDetail>
    
    func createSnapShot(){
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.fetchedRecipe , toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - Data Fetch Methods
    //this method creates a URL object from a specific text
    func createRecipeURL(from text: String) -> URL? {
        
        //remove any spaces or characters are not allowed in a url
        guard let cleanURL = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Can't make a url from :\(text)")
        }
        
        //build the urlstring using the clean string
        var urlString = "https://api.spoonacular.com/food/search"
        urlString = urlString.appending("?query=\(cleanURL)")
        urlString = urlString.appending("&apiKey=\(API_KEY)")
        
        return URL(string: urlString)
        
    }
    //fetch Recipe from search string
    func fetchRecipe(from url: URL, for searchString: String ){
        //create a new data task
        let recipeTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            //mark sure there is no error
            if let dataError = error {
                print("Could not fetch recipes: \(dataError.localizedDescription)")
              
            } else {
                
                do {
                    //make sure that some data was returned
                    guard let someData = data else {
                        return
                    }
                    
                    //decode the returned data
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Recipes.self, from: someData)
                    self.recipes = downloadedResults.searchResults
                    
                    for recipeDetail in self.recipes{
                        for foodItem in recipeDetail.results{
                            self.food.append(foodItem)
                        }
                    }
             
                    DispatchQueue.main.async {
                        let fetchedFood = Set(self.food)
                        self.fetchedRecipe = Array(fetchedFood)
                        self.createSnapShot()
                        //If the user search return nothing alert dialog will show no results returned to the user
                        if(self.food.count == 0){
                            let alert = UIAlertController(title: "No Results Found", message: nil, preferredStyle: .alert)
                         
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                            self.recipeSearchBar.text = ""
                        }
                        }
                    }
                    
                catch DecodingError.keyNotFound(let key, let context){
                    print("Error with key - \(key): \(context)")
                } catch DecodingError.valueNotFound(let value, let context){
                    print("Missing value - \(value): \(context)")
                } catch let error {
                    print("Problem decoding: \(error.localizedDescription)")
                }
            }
        }
        //run the task
        recipeTask.resume()
    }
    
    //Fetch image from image url
    func fetchImage(for path: String, in cell: RecipeTableViewCell){
        guard let imageUrl = URL(string: path)else{
            print("Can't make a url from \(path)")
            return
        }
        
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            if error == nil, let url = url, let data = try?
                Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async{
                    cell.recipeImage.image = image
                }
            }
            
        }
        imageFetchTask.resume()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else{ return }
        
        let selectedRecipe = dataSource.itemIdentifier(for: selectedIndex)
        //on selecting any recipe navigate to recipe detail screen
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.recipe = selectedRecipe
        destinationVC.recipeList = recipeList
        destinationVC.coreDataStack = coreDataStack
    }
    
}

//MARK: - SearchBar Delegate methods
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchtext = searchBar.text else{
            searchBar.resignFirstResponder()
            return
        }
        
        //if we can create a recipe url with the text, fetch the recipes using it
        if let recipeUrl = createRecipeURL(from: searchtext){
            fetchRecipe(from: recipeUrl, for: searchtext)
        }
        searchBar.resignFirstResponder()
    }
}

//MARK: - TableView Delegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

