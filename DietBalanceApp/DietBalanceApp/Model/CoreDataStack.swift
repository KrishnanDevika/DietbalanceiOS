//
//  CoreDataStack.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-26.
//

import Foundation
import CoreData

class CoreDataStack{
    private let modelName: String
    
    init(modelName: String){
        self.modelName = modelName
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores{
            storeDescription, error in
            if let error = error {
                fatalError("Unresolved error loading the persistent container - \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext = {
        return self.container.viewContext
    }()
    
    func saveContext(){
        guard managedContext.hasChanges else { return }
        
        do{
            try managedContext.save()
        } catch {
            fatalError("Unresolved error when trying to save - \(error.localizedDescription)")
        }
    }
}


