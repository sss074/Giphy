//
//  DataManager.swift
//  Giphy
//
//  Created by Sergiy Bekker on 02.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    var operationQueue:OperationQueue!
    
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
    
    override init() {
        super.init()
        operationQueue = OperationQueue()
    }
    //MARK: - Public methods
    
    func saveItems(_ content : Array<GiphyModel>){
        
        operationQueue.cancelAllOperations()
        self.removeItems()
        for obj in content{
            var item = NSEntityDescription.insertNewObject(forEntityName: "GiphyData",
                                                           into: self.managedObjectContext) as! GiphyData
            item.id = obj.id;
            item.imagelink = obj.imageUrl
            item.time = obj.import_datetime;
            
        }
        self.saveContext()
    }
    func getItems() -> (Array<GiphyModel>?){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GiphyData")
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            let temp:NSMutableArray = NSMutableArray()
            
            for obj in results as! [NSManagedObject] {
                let item:GiphyModel = GiphyModel()
                item.id = obj.value(forKey: "id") as! String
                item.import_datetime = obj.value(forKey: "time") as! String
                item.imageUrl = obj.value(forKey: "imagelink") as! String
                if (obj.value(forKey: "thublImg") as? Data) != nil{
                    item.imageThmbl = UIImage(data: (obj.value(forKey: "thublImg") as? Data)!)
                }
                if (obj.value(forKey: "gifImg") as? Data) != nil{
                    item.imageGif = UIImage(data: (obj.value(forKey: "gifImg") as? Data)!)
                }
                
                temp .add(item)
                
            }
            return temp as? Array
        } catch {
            print(error)
            return nil
        }
    }
    
    //MARK: - Private methods
    
    func updateThmblItem(_ image : UIImage, _ item: GiphyModel){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GiphyData")
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            let data = UIImagePNGRepresentation(image) as NSData?
            for obj in results as! [NSManagedObject] {
                if item.id == obj.value(forKey: "id") as! String{
                    obj.setValue(data, forKey: "thublImg")
                    break
                }
            }
            self.saveContext()
        } catch {
            print(error)

        }
        
    }
    
    func updateGifItem(_ image : UIImage, _ item: GiphyModel){
        
        
    }
    
    fileprivate func removeItems(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GiphyData")
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            for obj in results as! [NSManagedObject] {
                self.managedObjectContext.delete(obj)
            }
            self.saveContext()
        } catch {
            print(error)
        }
    }
    
    fileprivate func saveContext () {
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
    
    fileprivate func loadTmbls (_ content:Array<GiphyModel>){
        
        let operations = NSMutableArray()
        var pos = 0;
        
        for obj in content{
            let operation : BlockOperation = BlockOperation (block: {
                let manager:SDWebImageManager = SDWebImageManager.shared()
                let requestURL:NSURL = URL(string:obj.imageUrl)! as NSURL
                
                manager.loadImage(with: requestURL as URL, options: SDWebImageOptions.highPriority, progress: { (start, progress, url) in
                    
                }) { (image, data, error, cached, finished, url) in
                    if (error == nil && (image != nil) && finished) {
                        DispatchQueue.main.async {
                            self.updateThmblItem(image!, obj)
                        }
                    }
                }
            })
            operations.add(operation)
            pos += 1
            if pos > 0 {
                let opCur = operations.object(at: pos) as! BlockOperation
                let opLast = operations.object(at: pos - 1) as! BlockOperation
                opCur.addDependency(opLast)
            }
            operationQueue.addOperation(operation)
        }
    }
}
