//
//  Clothes+CoreDataProperties.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/29/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Clothes {

    @NSManaged var brand: String?
    @NSManaged var category: String?
    @NSManaged var color: String?
    @NSManaged var fabric: String?
    @NSManaged var from: String?
    @NSManaged var price: NSDecimalNumber?
    @NSManaged var style: String?
    @NSManaged var subcategory: String?
    @NSManaged var tag: String?
    @NSManaged var thumbnail: NSData?
    @NSManaged var fullsizeImg: FullsizeImages?
    @NSManaged var matches: NSSet?

}
