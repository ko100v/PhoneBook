
//  PhoneBookViewController.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/22/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PhoneBookViewController: BaseController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: -
    // MARK: Static Declaration
    
    // MARK: -
    // MARK: Public Interface
    
    // MARK: -
    // MARK: Private Interface
    
    private var allContacts: [Contact]!
    private var contacts: [[Contact]]!
    private var alphabet: [String]!
    private var isSearchnig: Bool = false
    private var oldSegmentIndex: Int = -1 {
        didSet {
            searchBar?.text = ""
            if oldSegmentIndex == -1 {
                // Normal data
                isSearchnig = false
                loadContacts()
            } else if oldSegmentIndex == 0 {
                // Only man
                isSearchnig = true
                allContacts = Array((try! Realm()).objects(Contact).filter("sex == 0"))
                tableView?.reloadData()
            } else if oldSegmentIndex == 1 {
                // Only woman
                isSearchnig = true
                allContacts = Array((try! Realm()).objects(Contact).filter("sex == 1"))
                tableView?.reloadData()
            }
        }
    }
    
    private var searchBar: UISearchBar? {
        didSet {
            searchBar?.delegate = self
            searchBar?.searchBarStyle = .Minimal
            searchBar?.placeholder = "Search by first name"
            view.addSubview(searchBar!)
        }
    }
    
    private var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.keyboardDismissMode = .OnDrag
            view.addSubview(tableView!)
        }
    }
    
    private var segmentControl: UISegmentedControl! {
        didSet {
            segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), forControlEvents: .ValueChanged)
            view.addSubview(segmentControl)
        }
    }
    
    // MARK: -
    // MARK: Constructors
    
    // MARK: -
    // MARK: Override Base
    
    override func setupUI() {
        super.setupUI()
        
        /**
         *  Initialization
         */
        searchBar = UISearchBar()
        tableView = UITableView()
        segmentControl = PBSegmentControl(items: ["Male", "Female"])
    }
    
    override func updateUI() {
        super.updateUI()
        // Load data
        loadContacts()
    }
    
    override func layoutUI() {
        super.layoutUI()
        
        /**
         *  Layout && Geometry
         */
        searchBar?.frame = CGRect(x: 0, y: Basic.Size.StatusBarHeight + Basic.Size.NavigationBarHeight, width: view.frame.size.width, height: Basic.Size.SearchBarHeight)
        segmentControl.frame = CGRectMake(Basic.Offset.x, searchBar!.frame.maxY + Basic.Offset.y, view.frame.size.width - 2*Basic.Offset.x, Basic.Size.SegmentHeight)
        tableView?.frame = CGRect(x: 0, y: segmentControl!.frame.maxY + Basic.Offset.x, width: view.frame.size.width, height: view.frame.size.height - (segmentControl!.frame.maxY + Basic.Offset.x))
    }
    
    // MARK: -
    // MARK: Public Implementation
    
    // MARK: -
    // MARK: Private Implementation
    
    /**
     Load all contacts
     */
    private func loadContacts() {

        let realm = try! Realm()
        allContacts = Array(realm.objects(Contact))
        
        if isSearchnig {
            oldSegmentIndex = segmentControl.selectedSegmentIndex
            tableView?.reloadData()
            return
        }
        
        // Get all alpha bets
        alphabet = getAphabet().sort({ $0 < $1 })
        
        // Create two dimensionsl contact array
        contacts = [[Contact]]()
        
        for letter in alphabet {
            self.contacts.append(allContacts.filter({ String($0.name.uppercaseString.characters.first!) == letter.uppercaseString  }).sort( { $0.name.uppercaseString < $1.name.uppercaseString } ))
        }
        
        // Reload data
        tableView?.reloadData()
    }
    
    /**
     Get all first letters from existing contacts
     
     - returns: [Character]
     */
    private func getAphabet() -> [String] {
        
        var alphabet = [String]()
        
        for contact in allContacts {
            if !alphabet.contains(String(contact.name.uppercaseString.characters.first!)) {
                alphabet.append(String(contact.name.uppercaseString.characters.first!))
            }
        }
        
        return alphabet
    }
    
    // MARK: -
    // MARK: Actions && Selectors
    
    func segmentValueChanged(sender: PBSegmentControl) {
        view.endEditing(true)
        if sender.selectedSegmentIndex != oldSegmentIndex {
            oldSegmentIndex = sender.selectedSegmentIndex
        } else if oldSegmentIndex == sender.selectedSegmentIndex {
            sender.selectedSegmentIndex = UISegmentedControlNoSegment
            oldSegmentIndex = -1
        }
    }
    
    // MARK: -
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            isSearchnig = true
            allContacts = SearchEngine.searchArray(allContacts, forText: searchText)
            tableView?.reloadData()
        } else {
            if oldSegmentIndex != -1 {
                oldSegmentIndex = segmentControl.selectedSegmentIndex
                return
            }
            isSearchnig = false
            // Load initial contacts
            loadContacts()
        }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate && UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isSearchnig ? 1 : alphabet.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchnig ? allContacts.count : contacts != nil ? contacts[section].count : 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifiers.DefaultCellId)
        // Get contact
        let contact = isSearchnig ? allContacts[indexPath.row] : contacts[indexPath.section][indexPath.row]
        // Set Values
        cell.textLabel?.text = "\(contact.name)  \(contact.lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchnig ? "Results" : alphabet[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return isSearchnig ? [String]() : alphabet
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        let newContactViewController = storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.NewContactViewController) as! NewContactViewController
        newContactViewController.contact = isSearchnig ? allContacts[indexPath.row] : contacts[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(newContactViewController, animated: true)
    }
    
}


class PBSegmentControl: UISegmentedControl {
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let previousSelectedSegmentIndex = self.selectedSegmentIndex
        super.touchesEnded(touches, withEvent: event)
        if previousSelectedSegmentIndex == self.selectedSegmentIndex {
            if let touch = touches.first {
                let touchLocation = touch.locationInView(self)
                if CGRectContainsPoint(bounds, touchLocation) {
                    self.sendActionsForControlEvents(.ValueChanged)
                }
            }
        }
    }
}
