//
//  CountriesViewController.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/22/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

/**
 *  **** CountriesViewControllerDelegate ****
 */
protocol CountriesViewControllerDelegate {
    
    /**
     Emits every time when user select country from countries list
     
     - parameter country: Country
     */
    func userDidSelectCountry(country: Country)
    
}

class CountriesViewController: BaseController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Static Declaration
    
    // MARK: -
    // MARK: Public Interface
    
    internal var delegate: CountriesViewControllerDelegate?
    
    // MARK: -
    // MARK: Private Interface
    
    private var countries: [Country]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .OnDrag
        }
    }
    
    private var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.searchBarStyle = .Minimal
            searchBar.placeholder = "Search"
        }
    }
    
    // MARK: -
    // MARK: ViewController LifeCycle
    
    // MARK: -
    // MARK: Override Base
    
    override func setupUI() {
        super.setupUI()
        
        /**
         Initialization
         */
        searchBar = UISearchBar()
        tableView = UITableView()
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        /**
         Configuration
         */
        loadCountries()
    }
    
    override func layoutUI() {
        super.layoutUI()
        
        searchBar.frame = CGRectMake(0, Basic.Size.StatusBarHeight + Basic.Size.NavigationBarHeight, view.frame.size.width, Basic.Size.SearchBarHeight)
        tableView.frame = CGRectMake(0, searchBar.frame.maxY, view.frame.size.width, view.frame.size.height - searchBar.frame.maxY)
    }
    
    // MARK: -
    // MARK: Public Implementation
    
    // MARK: -
    // MARK: Private Implementation
    
    /**
     Load countries from DataBase, if DataBase is nil, perform request and fill DB
     */
    private func loadCountries() {
        
        let realm = try! Realm()
        let countries = realm.objects(Country.self)
        if countries.isEmpty {
            
            // Show loading indicator
            // WARNING: Loading incicator
            
            
            APIManager.getCountries({ (countries) in
                
                // Loop thought all results
                for country in countries as! NSArray {
                    // Get name
                    let countryName = country[APIManager.APIConfig.Name] as! String
                    // Get calling code
                    let countryCallingCode = (country[APIManager.APIConfig.CallingCode] as! NSArray).firstObject as! String
                    
                    // Create new country
                    let newCountry = Country()
                    newCountry.name = countryName
                    newCountry.callingCode = countryCallingCode
                    // Increment Id
                    newCountry.id = newCountry.incrementID()
                    
                    // Save objects
                    let realm = try! Realm()
                    try! realm.write({
                        realm.add(newCountry)
                    })
                    
                    self.countries = Array(realm.objects(Country))
                }
                
                }, failiture: {
            })
        } else {
            // Reload data
            self.countries = Array((try! Realm().objects(Country)))
        }
        
    }
    
    // MARK: -
    // MARK: Actions && Selectors
    
    // MARK: -
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if user has type letters
        if !searchText.characters.isEmpty {
            countries = SearchEngine.filterArray(Array((try! Realm().objects(Country))), forText: searchText)
        } else {
            // Reload data
            self.countries = Array((try! Realm().objects(Country)))
        }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate && UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries != nil ? countries.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: CellIdentifiers.DefaultCellId)
        // Get country
        let country = countries[indexPath.row]
        // Set values
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.callingCode
        cell.detailTextLabel?.textColor = view.tintColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        /**
         *  Delegation
         */
        delegate?.userDidSelectCountry(countries[indexPath.row])
        // Remove view controller
        navigationController?.popViewControllerAnimated(true)
    }
}
