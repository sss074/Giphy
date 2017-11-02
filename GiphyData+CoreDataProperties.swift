//
//  GiphyData+CoreDataProperties.swift
//  
//
//  Created by Sergiy Bekker on 02.11.17.
//
//

import Foundation
import CoreData


extension GiphyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GiphyData> {
        return NSFetchRequest<GiphyData>(entityName: "GiphyData")
    }

    @NSManaged public var id: String?
    @NSManaged public var thublImg: NSData?
    @NSManaged public var gifImg: NSData?
    @NSManaged public var time: String?
    @NSManaged public var imagelink: String?

}
