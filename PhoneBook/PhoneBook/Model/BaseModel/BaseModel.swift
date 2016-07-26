//
//  BaseModel.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/25/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class BaseModel: Object {
    dynamic var name: String = ""
    dynamic var id: Int = 0
    
    /**
     Increment ID of realm database objects
     
     - returns: Int
     */
    func incrementID() -> Int {
        // Abstarct
       return 0
    }
}
