//
//  Task.swift
//  ToDoList
//
//  Created by Danial Zahid on 11/07/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object {

    dynamic var title : String?
    dynamic var descriptionText : String?
    dynamic var createdAt = Date()
    var priority = RealmOptional<Int>()
    dynamic var completed : Bool = false
    
}
