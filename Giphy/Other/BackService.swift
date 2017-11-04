//
//  BackService.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import UIKit


class BackService: NSObject {

    func data_request(param:String,  completion: @escaping (_ result: AnyObject) -> Void)
    {
        let requestURL:NSURL = URL(string:Constants().createRequestStr(param: param))! as NSURL
        
        var request = URLRequest(url: requestURL as URL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print(error ?? "")
            print(response ?? "")
            print(data ?? "")
            
            if (error != nil) {
                print(error ?? "")
            }
            else {
                do{
                    if let responseObj = try JSONSerialization.jsonObject(with: (data)!, options: .allowFragments) as? NSDictionary{
                        
                        if JSONSerialization.isValidJSONObject(responseObj){
                            completion(responseObj)
                        }
                        else{
                            if let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                                print("JSON: \n\n \(jsonString)")
                            }
                            fatalError("Can't parse JSON \(String(describing: error))")
                        }
                    }
                    
                }
                catch let error as NSError {
                    print("An error occurred: \(error)") }
            }
        })
        
        task.resume()
        
    }
    
    
}
