//
//  TaskItem.swift
//  quick2doo
//
//  Created by Joan Disho on 09.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RealmSwift

class TaskItem: Object {
    
    @objc dynamic let uid: Int = 0
    @objc dynamic let title: String = ""
    @objc dynamic let added: Date = Date()
    @objc dynamic let checked: Date? = nil
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}
