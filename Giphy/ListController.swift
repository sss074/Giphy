//
//  ViewController.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit


protocol ListControllerDelegate : NSObjectProtocol {
    func listContent(param: String)
    func selectItem(param: GiphyModel, target: UINavigationController)
}

class ListController: UIViewController, CooordinatorDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: - property
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var collectionView:UICollectionView!
    var lisContent: NSMutableArray! = NSMutableArray()
    fileprivate let reuseIdentifier = "ListCell"
    
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        title = "GIPHY SEARCH"
        clearSearchBar(searchBar)
        Cooordinator.sharedInstance.listContent(param:Constants.SEARCHEMPTY)
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
    
    func updateContent(content: Array<GiphyModel>) {
        lisContent.removeAllObjects()
        lisContent.addObjects(from: content)
        print(lisContent ?? "")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
 
    //MARK: -  Private methods
    
    fileprivate func parseSearch(_ searchBar: UISearchBar) -> String?{
        //let components = searchBar.text?.components(separatedBy: " ")
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
        Cooordinator.sharedInstance.listContent(param:parseSearch(searchBar)!)
        searchBar.resignFirstResponder()
    }
   

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        clearSearchBar(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        clearSearchBar(searchBar)
        Cooordinator.sharedInstance.listContent(param:Constants.SEARCHEMPTY)
    }
    
    //MARK: -  UICollectionView delagate
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     internal func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return lisContent!.count
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ListCell
        cell.displayContent(content:lisContent![indexPath.row] as! GiphyModel)

        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let  obj:GiphyModel = lisContent[indexPath.row] as! GiphyModel
        Cooordinator.sharedInstance.selectItem(param: obj, target: self.navigationController!)
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

