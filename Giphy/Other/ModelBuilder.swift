//
//  ModelBuilder.swift
//  Giphy
//
//  Created by Sergiy Bekker on 04.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

class ModelBuilder: NSObject {

    func gifModel(_ param:AnyObject) -> (GiphyModel) {
        return (GiphyModel(param as! NSDictionary))
    }
    
}
