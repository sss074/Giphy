//
//  GiphyModel.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

struct GifModel {
    var id: String!
    var imageUrl: String!
    var import_datetime: String!
    var imageThmbl: UIImage?
    var imageGif: UIImage?
}

class GiphyModel: NSObject {
   
    //MARK: Properties
    
    var model : GifModel!


    fileprivate func formatTime(_ param: NSDictionary) {
        let dateFormatter = DateFormatter()
        let dateString = param["import_datetime"] as? String
        let components = dateString?.components(separatedBy: " ")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.date(from: components![0])
        dateFormatter.dateStyle = DateFormatter.Style.medium
        model.import_datetime = dateFormatter.string(from: dateObj!)
    }
    
    fileprivate func formatUrlImage(_ param: NSDictionary) {
        let images = param["images"] as? NSDictionary
        if(images != nil){
            let original = images!["original"] as? NSDictionary
            if(original != nil){
                model.imageUrl = original!["url"] as? String
            }
        }
    }
    
    override init() {
        model = GifModel()
    }
    
    init(param: NSDictionary) {
        
        super.init()

        model = GifModel()
        model.id = param["id"] as? String
        formatTime(param)
        formatUrlImage(param)
    }
}
