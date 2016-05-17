//
//  Matches+CoreDataProperties.swift
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

extension Matches {

    @NSManaged var name: String?
    @NSManaged var thumbnail: NSData?
    @NSManaged var clothes: NSSet?
    @NSManaged var image: MatchImages?

}
