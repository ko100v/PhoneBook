//
//  Country.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/24/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Country: BaseModel {
    dynamic var callingCode: String = ""
    
    override func incrementID() -> Int {
        let realm = try! Realm()
        let currentId = realm.objects(Country).map( { $0.id } ).maxElement() ?? 0
        return currentId + 1
    }
}