//
//  Item.swift
//  Todoey
//
//  Created by Andrew Spry on 6/7/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title       : String = ""
    @objc dynamic var done        : Bool   = false
    @objc dynamic var dateCreated : Date?
    var               parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
