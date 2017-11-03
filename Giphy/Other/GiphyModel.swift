//
//  GiphyModel.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

class GiphyModel: NSObject {
   
    //MARK: Properties
    
    var id: String!
    var imageUrl: String!
    var import_datetime: String!
    var imageThmbl: UIImage?
    var imageGif: UIImage?

    fileprivate func formatTime(_ param: NSDictionary) {
        let dateFormatter = DateFormatter()
        let dateString = param["import_datetime"] as? String
        let components = dateString?.components(separatedBy: " ")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.date(from: components![0])
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.import_datetime = dateFormatter.string(from: dateObj!)
    }
    
    fileprivate func formatUrlImage(_ param: NSDictionary) {
        let images = param["images"] as? NSDictionary
        if(images != nil){
            let original = images!["original"] as? NSDictionary
            if(original != nil){
                self.imageUrl = original!["url"] as? String
            }
        }
    }
    
    override init() {
    }
    init(param: NSDictionary) {
        
        super.init()
        
        self.id = param["id"] as? String
        formatTime(param)
        formatUrlImage(param)
    }
}
