//
//  NewContactViewController.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/22/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class NewContactViewController: BaseController, UITextFieldDelegate, CountriesViewControllerDelegate {
    
    // MARK: -
    // MARK: Static Declaration
    
    private struct TFTags {
        static let FirstName = 0
        static let LastName: Int = 1
        static let PhoneNumber: Int = 2
        static let Country: Int = 3
        static let Code: Int = 4
        static let Email: Int = 5
    }

    // MARK: -
    // MARK: Public Interface
    
    internal var contact: Contact? {
        didSet {
            
        }
    }
    

    // MARK: -
    // MARK: Private Interface
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.layer.cornerRadius = titleLabel.frame.size.width / 2
            titleLabel.clipsToBounds = true
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            /**
             *  Configuration
             */
            textFields.forEach { (textField) in
                textField.delegate = self
                textField.addTarget(self, action: #selector(inputTextDidChanged(_:)), forControlEvents: .EditingChanged)
            }
        }
    }
    
    @IBOutlet weak var segmentControll: UISegmentedControl! {
        didSet {
        }
    }
    
    // MARK: -
    // MARK: Constructors
    
    init(contact: Contact) {
        super.init(nibName: nil, bundle: nil)
        // Set contact
        self.contact = contact
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: Override Base
    
    override func setupUI() {
        super.setupUI()
        
        /**
         Initialization
         */
        if contact == nil {
            contact = Contact()
        } else {
            editContact()
        }
    }
    
    // MARK: -
    // MARK: Public Implementation
    
    // MARK: -
    // MARK: Private Implementation
    
    /**
     Intitialize and present CountriesViewController
     */
    private func initCountriesViewController() {
        // Init
        let countriesVC = storyboard!.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.CountriesViewController) as! CountriesViewController
        countriesVC.delegate = self
        // Push
        navigationController?.pushViewController(countriesVC, animated: true)
    }
    
    private func editContact() {
        // Setup new bar button items
        navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editButtonPressed(_:)))
        
        // Get country
        let country = (try! Realm()).objects(Country).filter("id == \(contact!.countryId)").first!
        // Set sex
        segmentControll.selectedSegmentIndex = Int(contact!.sex)
        segmentControll.userInteractionEnabled = false
        
        // Set label
        titleLabel.text = String(contact!.name.characters.first!) + String(contact!.lastName.characters.first!)
        
        textFields.forEach { (textField) in
            // Disable interaction
            textField.userInteractionEnabled = false
            // Fill data
            switch textField.tag {
            case TFTags.FirstName: textField.text = contact?.name
            case TFTags.LastName: textField.text = contact?.lastName
            case TFTags.Country: textField.text = country.name
            case TFTags.Code: textField.text = country.callingCode
            case TFTags.PhoneNumber: textField.text = contact?.phoneNumber
            case  TFTags.Email: textField.text = contact?.email
            default: break
            }
        }
    }
    
    // MARK: -
    // MARK: Actions && Selectors
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        // Hide keyboard
        self.view.endEditing(true)
        
        // Dissmis view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
       
        // Hide keyboard
        view.endEditing(true)

        // Increment Id
        contact!.id = contact!.incrementID()
        
        // Save object
        let realm = try! Realm()
        try! realm.write({
            realm.add(contact!)
        })
        
        // Dismis view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func segmentControlValueChanged(sender: UISegmentedControl) {
        // Set sex
        try! Realm().write({ 
            self.contact!.sex = Bool(sender.selectedSegmentIndex)
        })
    }
    
    func inputTextDidChanged(textField: UITextField) {
        // Check values of all textFields
        navigationItem.rightBarButtonItem!.enabled = (textFields.filter( { $0.text!.characters.isEmpty }).count == 0) ? true : false
    }
    
    func editButtonPressed(sender: UIBarButtonItem) {
        // Enable UI
        textFields.forEach({ $0.userInteractionEnabled = true })
        segmentControll.userInteractionEnabled = true
        
        // Set new right button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonPressed(_:)))
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        // Save object
//        let realm = try! Realm()
//        try! realm.write({
//            realm.add(contact!)
//        })
        
        // Dismis view controller
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: UITextFieldDelegate 

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        switch textField.tag {
            case TFTags.Country, TFTags.Code:
                initCountriesViewController()
                return false
            default: return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        try! Realm().write({
            switch textField.tag {
            case TFTags.FirstName: contact?.name = textField.text!
            case TFTags.LastName: contact?.lastName = textField.text!
            case TFTags.PhoneNumber: contact?.phoneNumber = textField.text!
            case TFTags.Email: contact?.email = textField.text!
            default: break
            }
        })
    }
    
    // MARK: -
    // MARK: CountriesViewControllerDelegate
    
    func userDidSelectCountry(country: Country) {
        try! Realm().write({
            // Set contact id
            contact?.countryId = country.id
            // Set textfields values
            textFields.forEach { (textField) in
                switch textField.tag {
                case TFTags.Country: textField.text = country.name
                case TFTags.Code: textField.text = country.callingCode
                default: break
                }
            }
        })
        // Check values of all textfields
        textFields.forEach({ inputTextDidChanged($0) })
    }
}
