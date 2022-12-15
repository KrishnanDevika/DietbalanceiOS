//
//  UserFavouriteCollectionViewController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-11-02.
//

import UIKit
import CoreData
import CoreSpotlight
import SafariServices

class UserFavouriteCollectionViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var coreDataStack : CoreDataStack!
    var recipeCollections = [FavouriteRecipes]()
    let spacing: CGFloat = 5
 
    
    //MARK: - Collection View Diffable DataSource
    //Diffable data souce for handling collection view data
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, FavouriteRecipes>(collectionView: collectionView){
        collectionView, indexPath, recipe in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFavCell", for: indexPath) as! FavouritesCollectionViewCell
       
        let foods = self.recipeCollections[indexPath.row]
        cell.recipeNameLabel.text = foods.foodName
    
        self.fetchImage(for: foods.foodImage, in: cell)
   
        return cell
    }

    //MARK: - Snapshot methods
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FavouriteRecipes>
    
    func createSnapShot(){
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipeCollections, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    //MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        self.collectionView?.collectionViewLayout = layout
        fetchMyCollections()
        collectionView.delegate = self
        
        //Guesture 2 : LONG PRESS
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        collectionView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyCollections()
    }
    
    //MARK: - Fetch Data from Core Data
    func fetchMyCollections(){
      
        let fetchRequest: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        do {
            recipeCollections = try coreDataStack.managedContext.fetch(fetchRequest)
            self.createSnapShot()
        } catch {
            print("Problem fetching Recipes\(error)")
        }
    }
    
    //Fetch image from image url
    func fetchImage(for path: String, in cell: FavouritesCollectionViewCell){
        guard let imageUrl = URL(string: path)else{
            print("Can't make a url from \(path)")
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            if error == nil, let url = url, let data = try?
                Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async{
                    cell.recipeImageView.image = image
                }
            }
            
        }
        imageFetchTask.resume()
    }
    
    
    //MARK: - Gesture 2 Long Press
    //long press - Guesture Delete recipe from your favourites
    @objc func viewLongPressed(_ gesture: UILongPressGestureRecognizer){
        
         let recipe = gesture.location(in: self.collectionView)
        
         let indexPath = (self.collectionView?.indexPathForItem(at: recipe))!

        let alert = UIAlertController(title: "Delete this Recipe?", message: "Do you want to remove \(recipeCollections[indexPath.row].foodName) from your favourites list?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self]_ in
            guard let selectedFood = dataSource.itemIdentifier(for: indexPath) else { return }

            self.recipeCollections.remove(at: indexPath.row)
            createSnapShot()
            //remove from coreData
            self.coreDataStack.managedContext.delete(selectedFood)
            //save the context
            self.coreDataStack.saveContext()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert,animated: true)
        
    }
    
    //MARK: - SFSafariViewController to launch Web Page
    //SFSafariViewController, which effectively embeds all of Safari inside your app using an opaque view controller
    func showContent(_ id: Int) {
        //Create an URL
        for collection in recipeCollections {
            if collection.id == id{
                let recipeLink = collection.foodLink
                if let url = URL(string: recipeLink) {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    //Launch the web page using SFSafariViewController
                    let vc = SFSafariViewController(url: url, configuration: config)
                    present(vc, animated: true)
                }
            }
        }
    }
}

//MARK: - Delegate Methods
extension UserFavouriteCollectionViewController: UICollectionViewDelegate{
    
    //on item is selected add that item to the spotlight
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Added animation on cell showing the user that cell is selected.
         let cell = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                cell?.transform = cell!.isSelected ? CGAffineTransform(scaleX: 1.15, y: 1.15) : CGAffineTransform.identity
            }, completion: nil)
        
    }

    //Spacing between collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

}


//MARK: - CollectionView delegate Method
extension UserFavouriteCollectionViewController: UICollectionViewDelegateFlowLayout{

    //set spacing, width and height of each collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 230)
    }

    
}
