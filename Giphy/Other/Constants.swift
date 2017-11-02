//
//  Constant.swift
//  Giphy
//
//  Created by Sergiy Bekker on 01.11.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: List of Constants
    
    static let BASE_URL = "http://api.giphy.com/v1/gifs/search"
    static let API_KEY = "bQFhSa178ADmAbviVuSVkrX4K4aYheW0"
    static let SEARCHEMPTY = "sky"
    
    func createRequestStr(param:String) -> String
    {
        return "\(Constants.BASE_URL)?q=\(param)&api_key=\(Constants.API_KEY)"
    }
    
}
