//
//  SearchEngine.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/25/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class SearchEngine: NSObject {
    
    class func filterArray(array: [Country]!, forText searchText: String) -> [Country] {
        
        var filteredArray = [Country]()
        
        if array != nil {
            for object in array {
                
                if object.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil {
                    filteredArray.append(object)
                }
            }
        }
        
        return filteredArray
    }
    
    class func searchArray(array: [Contact]!, forText searchText: String) -> [Contact] {
        
        var filteredArray = [Contact]()
        
        if array != nil {
            for object in array {
                
                if object.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil {
                    filteredArray.append(object)
                }
            }
        }
        
        return filteredArray
    }
}