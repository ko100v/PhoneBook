//
//  APIManager.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/24/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    
    // MARK: -
    // MARK: Static Declaration
    
    internal struct APIConfig {
        static let URL: String = "https://restcountries.eu/rest/v1/all"
        static let Name: String = "name"
        static let CallingCode: String = "callingCodes"
    }
    
    // MARK: -
    // MARK: Public Interface
    
    internal class func getCountries(completion:(countries: AnyObject) -> Void, failiture:() -> Void) {
        
        Alamofire.request(.GET, APIConfig.URL).responseJSON { response in
            switch response.result {
            case .Success:
                completion(countries: response.result.value!)
            case .Failure:
                failiture()
            }
        }
    }
    
    // MARK: -
    // MARK: Private Interface
    
    // MARK: -
    // MARK: Public Implementation
    
    // MARK: -
    // MARK: Private Implementation
    
}