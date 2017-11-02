//
//  DataManager.swift
//  Giphy
//
//  Created by Sergiy Bekker on 02.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    //MARK: - CoreData stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Giphy", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Giphy.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: - Public methods
    
    public func checkContent(){
        
    }
    public func saveItems(_ : Array<GiphyModel>){
        
    }
    public func getItems() -> (Array<GiphyModel>?){
 
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GiphyData")
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            let temp:NSMutableArray = NSMutableArray()
            
            for obj in results as! [NSManagedObject] {
                let item:GiphyModel = GiphyModel()
                item.id = obj.value(forKey: "id") as! String
                item.import_datetime = obj.value(forKey: "time") as! String
                item.imageUrl = obj.value(forKey: "imagelink") as! String
                item.imageThmbl = UIImage(data: obj.value(forKey: "thublImg") as! Data)
                 item.imageGif = UIImage(data: obj.value(forKey: "gifImg") as! Data)
                temp .add(item)
                
            }
            return temp as? Array
        } catch {
            print(error)
            return nil
        }
    }
    
    //MARK: - Private methods
    
    fileprivate func removeItems(){
        
    }
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
