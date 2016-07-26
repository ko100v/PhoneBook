//
//  Contact.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/25/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Contact: BaseModel {
    dynamic var lastName: String = ""
    dynamic var countryId: Int = 0
    dynamic var phoneNumber: String = ""
    dynamic var email: String = ""
    /**
     * 0 - Male
     * 1 - Female
     */
    dynamic var sex: Bool = false
    
    override func incrementID() -> Int {
        let realm = try! Realm()
        let currentId = realm.objects(Contact).map( { $0.id } ).maxElement() ?? 0
        return currentId + 1
    }
}