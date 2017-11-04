//
//  Cooordinator.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

protocol CooordinatorDelegate : NSObjectProtocol {
    func updateContent(_ :  Array<GiphyModel>)
}

class Cooordinator: NSObject, ListControllerDelegate {

    static let sharedInstance = Cooordinator()
    weak var delegate: CooordinatorDelegate?
  
    
    
    func listContent(_ param: String){
        DataManager.sharedInstance.getContent(param: param, completion: { (result: AnyObject) in
            let responseObj = result as? NSDictionary
            let data = responseObj!["data"] as! NSArray
            let temp = NSMutableArray()
            for obj in data {
                temp .add(ModelBuilder().gifModel(obj as AnyObject))
            }
            let obj = temp as! Array<GiphyModel>
            DataManager.sharedInstance.saveItems(obj)
            self.delegate?.updateContent(obj)
        })
    }
    
    func selectItem(_ param: GiphyModel, _ target: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        detailController.content = param
        target.pushViewController(detailController, animated: true) 
    }
}
