//
//  MatchImages+CoreDataProperties.swift
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

extension MatchImages {

    @NSManaged var fullsizeimage: NSData?
    @NSManaged var match: Matches?

}
