//
//  ModelBuilder.swift
//  Giphy
//
//  Created by Sergiy Bekker on 04.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

class ModelBuilder: NSObject {

    func gifModel(_ param:AnyObject) -> (Array<GiphyModel>) {
        let responseObj = param as? NSDictionary
        let result = responseObj!["data"] as! NSArray
        let temp = NSMutableArray()
        for obj in result {
            temp .add(GiphyModel(param: obj as! NSDictionary))
        }
        DataManager.sharedInstance.saveItems(temp as! Array<GiphyModel>)
        return temp as! Array<GiphyModel>
    }
    
}
