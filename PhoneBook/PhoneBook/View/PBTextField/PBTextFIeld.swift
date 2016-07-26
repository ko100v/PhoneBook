//
//  PBTextFIeld.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/24/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import UIKit

class PBTextField: UITextField {
    
    // MARK: -
    // MARK: Static Declaration
    
    /**
     *  Textfield actions
     */
    private struct Actions {
        static let paste: Selector = #selector(paste(_:))
        static let select: Selector = #selector(select(_:))
        static let selectAll: Selector = #selector(selectAll(_:))
    }
    
    // MARK: -
    // MARK: Public Interface
    
    // MARK: -
    // MARK: Private Interface
    
    // MARK: -
    // MARK: Constructors
    
    // MARK: -
    // MARK: Override Base
    
    // MARK: -
    // MARK: Public Implementation
    
    // MARK: -
    // MARK: Private Implementation
    
    // MARK: -
    // MARK: Actions && Selectors
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        switch action {
        case Actions.paste: return false
        case Actions.select: return false
        case Actions.selectAll: return false
        default:
            return true
        }
    }
    
}
