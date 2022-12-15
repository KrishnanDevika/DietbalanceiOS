//
//  SceneDelegate.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-09-29.
//

import UIKit
import CoreSpotlight

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    lazy var coreDataStack =  CoreDataStack(modelName: "NutritionData")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let rootVC = window?.rootViewController as? UITabBarController,
              let navVC = rootVC.viewControllers?[1] as? UINavigationController,
              let searchVC = navVC.viewControllers[0] as? ViewController,
              let navhealthyVC = rootVC.viewControllers?[2] as? UINavigationController,
              let recipeVC = navhealthyVC.viewControllers[0] as? HealthyRecipeViewController,
              let navFavVC = rootVC.viewControllers?[3] as? UINavigationController,
              let FavVC = navFavVC.viewControllers[0] as? UserFavouriteCollectionViewController
              
        else { return }
      
        //Passing same instance of core data to all the screens
        searchVC.coreDataStack = coreDataStack
        recipeVC.coreDataStack = coreDataStack
        FavVC.coreDataStack = coreDataStack
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        //Implement core spotlight
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                    if let tabBar = window?.rootViewController as? UITabBarController {
                        if let navVC = tabBar.viewControllers?[3] as? UINavigationController{
                        if let favVC = navVC.viewControllers[0] as? UserFavouriteCollectionViewController{
                            DispatchQueue.main.async {
                                //Using the index passed from spotlight launch the web page
                                favVC.showContent(Int(uniqueIdentifier)!)
                            }
                        }
                    }
                }
            }
        }
    }


}

