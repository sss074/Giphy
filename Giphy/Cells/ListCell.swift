//
//  ListCell.swift
//  Giphy
//
//  Created by Sergiy Bekker on 02.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit
import SDWebImage

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var borderView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        borderView?.isHidden = true
    }
    
    func displayContent(content: GiphyModel) {
        
        timeLabel?.text = content.model.import_datetime
        
        if content.model.imageThmbl != nil{
            self.imageView?.image = content.model.imageThmbl
        } else {
            let manager:SDWebImageManager = SDWebImageManager.shared()
            let requestURL:NSURL = URL(string:content.model.imageUrl)! as NSURL
            
            manager.loadImage(with: requestURL as URL, options: SDWebImageOptions.highPriority, progress: { (start, progress, url) in
                
            }) { (image, data, error, cached, finished, url) in
                if (error == nil && (image != nil) && finished) {
                    DispatchQueue.main.async {
                        self.imageView?.image = image
                    }
                }
            }
        }
    }
    func toggleSelected () {
        borderView?.isHidden = !isSelected
    }
   
}
