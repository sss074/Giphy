//
//  DetailController.swift
//  Giphy
//
//  Created by Sergiy Bekker on 02.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var content:GiphyModel!
    var operationQueue:OperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        operationQueue = OperationQueue()
        title = self.content.import_datetime
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if content.imageThmbl != nil{
            self.imageView?.image = content.imageGif
        } else {
            let operation : BlockOperation = BlockOperation (block: {
                self.loadGif()
            })
            operationQueue.addOperation(operation)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        operationQueue.cancelAllOperations()
    }
    
    func loadGif() {
        let imageURL = UIImage.gifImageWithURL(self.content.imageUrl!)
        DispatchQueue.main.async {
            self.imageView?.image = UIImageView(image: imageURL).image
        }
        
    }
}
