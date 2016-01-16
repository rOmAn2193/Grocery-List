//
//  Item+CoreDataProperties.swift
//  Grocery List
//
//  Created by Roman on 1/15/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var note: String?
    @NSManaged var qty: String?

}
