//
//  Category.swift
//  Todoey
//
//  Created by Andrew Spry on 6/7/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name  : String = ""
    @objc dynamic var color : String = ""
    let               items          = List<Item>()
}
