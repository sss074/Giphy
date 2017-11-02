//
//  Cooordinator.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

protocol CooordinatorDelegate : NSObjectProtocol {
    func updateContent(content:  Array<GiphyModel>)
}

class Cooordinator: NSObject, ListControllerDelegate {

    static let sharedInstance = Cooordinator()
    weak var delegate: CooordinatorDelegate?
    
    func listContent(param: String){
        BackService.sharedInstance.data_request(param: param, completion: { (result: NSArray) in
            let temp = NSMutableArray()
            for obj in result {
                temp .add(GiphyModel(param: obj as! NSDictionary))
            }
            self.delegate?.updateContent(content: temp as! Array<GiphyModel>)
        })
    }
    
    func selectItem(param: GiphyModel, target: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        detailController.content = param
        target.pushViewController(detailController, animated: true) 
    }
}
