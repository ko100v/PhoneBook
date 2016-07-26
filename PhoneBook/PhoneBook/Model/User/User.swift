//
//  User.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/25/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: BaseModel {
    var contacts = List<Contact>()
}