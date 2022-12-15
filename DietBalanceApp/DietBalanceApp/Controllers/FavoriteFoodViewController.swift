//
//  FavoriteFoodViewController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-26.
//

import UIKit

class FavoriteFoodViewController: UIViewController {
    
    //MARK: - Properties
    
    var favouriteFoods : Foods?
    
    //MARK: - Outlets

    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var caloriesText: UILabel!
    @IBOutlet weak var proteinsText: UILabel!
    @IBOutlet weak var carbsText: UILabel!
    @IBOutlet weak var fatText: UILabel!
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foodImage.layer.cornerRadius = 15
        //Populate this page with the recipe data passed from healthy recipe page
        if let food = favouriteFoods{
            foodTitle.text = food.title
            caloriesText.text = "\(food.calories) cal"
            proteinsText.text = food.protein
            carbsText.text = food.carbs
            fatText.text = food.fat
            
            self.fetchImage(for: food.image)
            
        }
    }
    
    
    //MARK: - Fetch Image from URL
    //Fetch image from image url
    func fetchImage(for path: String){
        guard let imageUrl = URL(string: path)else{
            print("Can't make a url from \(path)")
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            if error == nil, let url = url, let data = try?
                Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async{
                    self.foodImage.image = image
                }
            }
            
        }
        imageFetchTask.resume()
    }


}
