//
//  Item+CoreDataProperties.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 5/1/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var category: Category?

}
