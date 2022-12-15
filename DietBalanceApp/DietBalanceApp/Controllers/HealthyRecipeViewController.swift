//
//  HelathyRecipesViewController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-13.
//

import UIKit
import CoreData

class HealthyRecipeViewController: UIViewController , UITableViewDelegate, UICollectionViewDelegate, UITextFieldDelegate {
    
    //MARK: - Properties
    var recipesList = [HealthyRecipe]()
    var myFavorites = [HealthyRecipe]()
    var coreDataStack : CoreDataStack!
    var myFoods = [Foods]()
    var minCarbs = 0
    var maxCarbs = 0
    var minProtein = 0
    var maxProtein = 0
    var minFat = 0
    var maxFat = 0
    
    //MARK: - Outlets

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var favoriteRecipeTableView: UITableView!
    
    
    //MARK: - Action
    //Allow user can able to search recipe by nutrients. The user can enter the content of carbs, fat, protein
    @IBAction func filterSearch(_ sender: Any) {
        let filterMessage = UIAlertController(title: "Nutrient Limits", message: "Search recipes by Nutrients", preferredStyle: .alert)
        // Add text field
        filterMessage.addTextField(configurationHandler: { carbTextField in
            carbTextField.placeholder = "Enter Min Carbs 10 - 100 grams"
            carbTextField.keyboardType = .numberPad
        })
        filterMessage.addTextField(configurationHandler: { maxCarbTextField in
            maxCarbTextField.placeholder = "Enter Max Carbs 10 - 100 grams"
            maxCarbTextField.keyboardType = .numberPad
        })
        filterMessage.addTextField(configurationHandler: { minProteinTextField in
            minProteinTextField.placeholder = "Enter Min Protein Content 10 - 100 grams"
            minProteinTextField.keyboardType = .numberPad
        })
        filterMessage.addTextField(configurationHandler: { proteinTextField in
            proteinTextField.placeholder = "Enter Max Protein Content 10 - 100 grams"
            proteinTextField.keyboardType = .numberPad
        })
        filterMessage.addTextField(configurationHandler: { fatTextField in
            fatTextField.placeholder = "Enter Min Fat Content  1 - 100 grams"
            fatTextField.keyboardType = .numberPad
        })
        filterMessage.addTextField(configurationHandler: { maxFatTextField in
            maxFatTextField.placeholder = "Enter Max Fat Cntent 10 - 100 grams"
            maxFatTextField.keyboardType = .numberPad
        })

        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if let carbs =  filterMessage.textFields![0].text{
                if let minCarb = Int(carbs){
                self.minCarbs = minCarb
                }
            }
            if let carbs =  filterMessage.textFields![1].text{
                if let maxCarb = Int(carbs){
                self.maxCarbs = maxCarb
                }
            }
            if let proteins =  filterMessage.textFields![2].text{
                if let protein = Int(proteins){
                self.minProtein = protein
                }
            }
            if let proteins =  filterMessage.textFields![3].text{
                if let protein = Int(proteins){
                self.maxProtein = protein
                }
            }
       
            if let fat =  filterMessage.textFields![4].text{
                if let fat = Int(fat){
                self.minFat = fat
                }
            }
            if let maxFat =  filterMessage.textFields![5].text{
                if let maxFat = Int(maxFat){
                self.maxFat = maxFat
                }
            }
        
            DispatchQueue.main.async {
                //Based on the nutrients users entered form the url and fetch the reipes from the api
                var urlString = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=\(self.minCarbs)&maxCarbs=\(self.maxCarbs)&minProtein=\(self.minProtein)&maxProtein=\(self.maxProtein)&minFat=\(self.minFat)&maxFat=\(self.maxFat)&number=100"
                urlString = urlString.appending("&apiKey=\(API_KEY)")
                self.fetchHealthyRecipe(from: URL(string: urlString)!)
            }
        })
        filterMessage.addAction(ok)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        filterMessage.addAction(cancelAction)
       // Present dialog message to user
       self.present(filterMessage, animated: true, completion: nil)
    
    }
    
    //MARK: - Datasources and snapshot methods
    //Datasource for collection view
    private lazy var collectionDataSource = UICollectionViewDiffableDataSource<Section, HealthyRecipe>(collectionView: recipeCollectionView){
        collectionview, indexpath, healthyRecipe in
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "RecipeImageCell", for: indexpath) as? RecipeCollectionViewCell
        cell?.recipeName.text = healthyRecipe.title
        if let recipeImage = healthyRecipe.image{
            self.fetchImage(for: recipeImage, in: cell!)
        }
        
        
        return cell
    }
    
    //DataSource for table view
    private lazy var tableDataSource = UITableViewDiffableDataSource<Section, Foods>(tableView: favoriteRecipeTableView){
        tableview, indexpath, recipes in
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "FavouriteRecipeCell", for: indexpath) as? HealthRecipeyTableCell
        cell?.healthyRecipeName?.text = recipes.title
        cell?.healthyrecipeCalories?.text = "Calories : \(recipes.calories)"
    
        self.fetchImageforTable(for: recipes.image, in: cell!)

      
        
        return cell
    }
    
    //Create Snapshot for collection view
    func loadCollection(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, HealthyRecipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipesList, toSection: .main)
        collectionDataSource.apply(snapshot)
    }
    
    //Cfreate snapshot for tableView
    func loadTable(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Foods>()
        snapshot.appendSections([.main])
        snapshot.appendItems(myFoods, toSection: .main)
        tableDataSource.apply(snapshot)
    }
    
    
    
    //MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        //build the urlstring using the clean string
        var urlString = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=10&maxCarbs=30&&minProtein=20&maxProtein=80&minFat=10&maxFat=20&number=100"
        urlString = urlString.appending("&apiKey=\(API_KEY)")
        //Fetch data from urlstring
        fetchHealthyRecipe(from: URL(string: urlString)!)
        
        recipeCollectionView.delegate = self
        favoriteRecipeTableView.delegate = self
        
        //setup drag candidate
        recipeCollectionView.dragDelegate = self
        recipeCollectionView.dragInteractionEnabled = true
        
        //setup drop candidate
        favoriteRecipeTableView.dropDelegate = self
        fetchMyFoods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCollection()
    }
    
    //MARK: - Fetch Data from Core Data
    func fetchMyFoods(){
        let fetchRequest: NSFetchRequest<Foods> = Foods.fetchRequest()
        do {
            myFoods = try coreDataStack.managedContext.fetch(fetchRequest)
            loadTable()
        } catch {
            print("Problem fetching Recipes \(error)")
        }
    }
    
    
    //MARK: - Fetch Data from API
    //fetch Recipe from url string
    func fetchHealthyRecipe(from url: URL){
        //create a new task
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
                    let downloadedResults = try jsonDecoder.decode([HealthyRecipe].self, from: someData)
                    self.recipesList = downloadedResults
                    
                    DispatchQueue.main.async {
                        self.loadCollection()
                        if self.recipesList.count == 0{
                            let alert = UIAlertController(title: "Recipes", message: "No Recipes Found", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default){
                                [weak self] _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            
                            self.present(alert,animated: true)
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
    //Fetch image for collection view cell from image url
    func fetchImage(for path: String, in cell: RecipeCollectionViewCell){
        guard let imageUrl = URL(string: path)else{
            print("Can't make a url from \(path)")
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            if error == nil, let url = url, let data = try?
                Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async{
                    cell.healthyRecipeImage.image = image
                }
            }
            
        }
        imageFetchTask.resume()
    }
    
    
    //Fetch image  for table view cell from image url
    func fetchImageforTable(for path: String, in cell: HealthRecipeyTableCell){
        guard let imageUrl = URL(string: path)else{
            print("Can't make a url from \(path)")
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            if error == nil, let url = url, let data = try?
                Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async{
                    cell.healthyImageView?.image = image
                }
            }
            
        }
        imageFetchTask.resume()
    }
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "HEALTHY RECIPES"
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
    
        return label
    }
    
    
    //MARK: - Gesture 3 Swipe Gesture
    //Delete recipe from your favorites
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)-> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "remove") { (_, _, completionHandler) in
                //determine what was selected
                guard let selectedFood = self.tableDataSource.itemIdentifier(for: indexPath) else { return }

                //remove from coreData
                self.coreDataStack.managedContext.delete(selectedFood)
                //save the context
                self.coreDataStack.saveContext()

                //remove from the PlantOrders array
                self.myFoods.remove(at: indexPath.row)
                self.loadTable()
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash.square")
            deleteAction.backgroundColor = UIColor(hue: 7.0, saturation: 1, brightness: 0.58, alpha: 1)

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }

    

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let selectedIndex = favoriteRecipeTableView.indexPathForSelectedRow else{ return }
        
        let selectedFood = myFoods[selectedIndex.row]
        //on selecting any recipe navigate to FavoriteFoodViewController
        let destinationVC = segue.destination as! FavoriteFoodViewController
        // Pass the selected object to the new view controller.
        destinationVC.favouriteFoods = selectedFood    
    }
    
    //MARK: - Alert Methods
     func showAlertDialog(withTitle title: String, withMessage message: String){
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default){
             [weak self] _ in
             self?.navigationController?.popViewController(animated: true)
         }
         alert.addAction(okAction)
         
         present(alert,animated: true)
     
     }

}

//MARK: - CollectionView Delegate Methods
extension HealthyRecipeViewController: UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragCharacter = recipesList[indexPath.item]
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragCharacter
        
        //check if the myFoods array is empty
        if myFoods.isEmpty{
            let newFood = Foods(context: self.coreDataStack.managedContext)
            newFood.title = recipesList[indexPath.item].title
            if let image =  recipesList[indexPath.item].image{
                newFood.image = image
            }
            newFood.calories = Int64(recipesList[indexPath.item].calories)
            newFood.carbs = recipesList[indexPath.item].carbs
            newFood.fat = recipesList[indexPath.item].fat
            newFood.protein = recipesList[indexPath.item].protein
            self.myFoods.append(newFood)
            self.coreDataStack.saveContext()
        }//else add the recipe to myFoods array
        else{
 
          var count = 0
            for food in myFoods{
                if food.title != dragCharacter.title{
                    count += 1
                }
            }
            if count == myFoods.count{
                let newFood = Foods(context: self.coreDataStack.managedContext)
                newFood.title = recipesList[indexPath.item].title
                if let image =  recipesList[indexPath.item].image{
                    newFood.image = image
                }
                newFood.calories = Int64(recipesList[indexPath.item].calories)
                newFood.carbs = recipesList[indexPath.item].carbs
                newFood.fat = recipesList[indexPath.item].fat
                newFood.protein = recipesList[indexPath.item].protein
            self.myFoods.append(newFood)
           
            //save the new product
            self.coreDataStack.saveContext()
            }else{
                dragItem.localObject = nil
                showAlertDialog(withTitle: "The Recipe \(dragCharacter.title) is already available in your list", withMessage: "")
            }
        }
        
        return [dragItem]
    }
    
    
    
}


//MARK: - Tableview Delegate Method
extension HealthyRecipeViewController : UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let section = tableView.numberOfSections - 1
        let row = tableView.numberOfRows(inSection: section)
        
        let destinationIndexPath = IndexPath(row: row, section: section)
        
        for item in coordinator.items{
            if let dropCharacter = item.dragItem.localObject as? Foods, !myFoods.contains(dropCharacter){
                myFoods.insert(dropCharacter, at: destinationIndexPath.row)
            }
        }
        
        DispatchQueue.main.async {
            self.loadTable()
        }
        

    }
}





