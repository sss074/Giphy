//
//  ViewController.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit


protocol ListControllerDelegate : NSObjectProtocol {
    func listContent(_ : String)
    func selectItem(_ : GiphyModel, _ : UINavigationController)
}

class ListController: UIViewController, CooordinatorDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: - property
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var collectionView:UICollectionView!
    var lisContent = NSMutableArray()
    fileprivate let reuseIdentifier = "ListCell"
    
    
    //MARK: -
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        title = "GIPHY SEARCH"
        clearSearchBar(searchBar)
        checkContent()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Cooordinator.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Cooordinator.sharedInstance.delegate = nil
        
    }
    
    //MARK: - Coordinator delegate
    
    func updateContent(_ content: Array<GiphyModel>) {
        lisContent.removeAllObjects()
        lisContent.addObjects(from: content)
        print(lisContent ?? "")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
 
    //MARK: -  Private methods
    
    fileprivate func checkContent() {
        let content = DataManager.sharedInstance.getItems() as! Array<GiphyModel>
        if content.count > 0{
            lisContent .addObjects(from: content)
            self.collectionView.reloadData()
        } else {
            if self.isInternetAvailable() {
                Cooordinator.sharedInstance.listContent(Constants.SEARCHEMPTY)
            }
        }
    }
    
    fileprivate func parseSearch(_ searchBar: UISearchBar) -> String?{

        var appendString: String = ""

        guard let components = searchBar.text?.components(separatedBy: " ") else {
            return nil
        }
        
        for (index, obj) in (components.enumerated()) {
            if(index == 0){
                appendString = obj
            } else {
                appendString = "\(appendString)+\(obj)"
            }
        }
        
        return appendString
    }
    
    fileprivate func clearSearchBar(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.placeholder = "Search text"
    }
    
    //MARK: -  UISearchBar delagate
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        Cooordinator.sharedInstance.listContent(parseSearch(searchBar)!)
        searchBar.resignFirstResponder()
    }
   
    internal func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        clearSearchBar(searchBar)
        if !self.isInternetAvailable() {
            let alert = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        clearSearchBar(searchBar)
        Cooordinator.sharedInstance.listContent(Constants.SEARCHEMPTY)
    }
    
    //MARK: -  UICollectionView delagate
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     internal func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return lisContent.count
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ListCell
        cell.displayContent(content:lisContent[indexPath.row] as! GiphyModel)

        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView .cellForItem(at: indexPath) as! ListCell
        cell.toggleSelected()
        
        let  obj:GiphyModel = lisContent[indexPath.row] as! GiphyModel
        Cooordinator.sharedInstance.selectItem(obj, self.navigationController!)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView .cellForItem(at: indexPath) as! ListCell
        cell.toggleSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width:(collectionView.frame.size.width / 3.0 - 10.0), height: collectionView.frame.size.width / 3.0 - 10.0)
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
}

