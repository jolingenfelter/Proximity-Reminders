//
//  AddLocationViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/19/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import MapKit

enum ReminderType: String {
    case Arrival
    case Departure 
}

class AddLocationViewController: UIViewController {
    
    // View Variables
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }()
    
    lazy var notificationTimeOptionButtons: UISegmentedControl = {
        
        let items = ["Reminder on arrival", "Reminder on departure"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(toggleSegmentController(sender:)), for: .valueChanged)
        
        return segmentedControl
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        return controller
    }()
    
    // Location Variables
    
    var searchLocations: [MKMapItem] = []
    let mapView = MKMapView()
    var locationToSave: CLLocation?
    var savedLocation: CLLocation?
    var locationManager: LocationManager?
    var locationName: MKPlacemark?
    
    // Other
    var reminderType: ReminderType?
    var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSetup()
        
        configureSearchController()
        searchController.loadViewIfNeeded()
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        
        locationManager = LocationManager()
        mapView.showsUserLocation = true
        
        self.definesPresentationContext = true
        
        reminderType = .Arrival
        
    }
    
    deinit {
        searchController.loadViewIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        // MapView
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        // SegmentedControl
        
        view.addSubview(notificationTimeOptionButtons)
        notificationTimeOptionButtons.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationTimeOptionButtons.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 5),
            notificationTimeOptionButtons.heightAnchor.constraint(equalToConstant: 25),
            notificationTimeOptionButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            notificationTimeOptionButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
        
        // SearchBar
        
        guard let searchBar = searchBar else {
            return
        }
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: notificationTimeOptionButtons.bottomAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)])
        
        // TableView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckLocationAdded"), object: nil, userInfo: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        locationToSave = nil
        savedLocation = nil
        locationName = nil
        reminderType = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: TableView

extension AddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let searchLocation = searchLocations[indexPath.row].placemark
        cell.textLabel?.text = searchLocation.name
        cell.detailTextLabel?.text = locationManager?.parseAddress(location: searchLocation)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchController.searchBar.endEditing(true)
        
        locationName = searchLocations[indexPath.row].placemark
        
        if let selectedLocation = locationName {
            locationManager?.dropPinAndZoom(mapView: self.mapView, placemark: selectedLocation)
            
            locationToSave = CLLocation(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude)
        }

    }
    
}

// MARK: SearchController

extension AddLocationViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchBar = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                return
            }
            
            self.searchLocations = response.mapItems
            self.tableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - SegmentedControll

extension AddLocationViewController {
    
    func toggleSegmentController(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0 :
            self.reminderType = ReminderType.Arrival
        
        case 1:
            self.reminderType = ReminderType.Departure
            
        default:
            break
            
        }
        
    }
    
}

// MARK: NavigationBar

extension AddLocationViewController {
    
    func navigationBarSetup() {
        
        let saveLocationButton = UIBarButtonItem(title: "Save Location", style: .plain, target: self, action: #selector(saveLocationPressed))
        navigationItem.rightBarButtonItem = saveLocationButton
        
    }
    
    func saveLocationPressed() {
        
        if locationToSave != nil {
            
            savedLocation = locationToSave
            
            guard let locationName = locationName else {
                return
            }
            
            if let locationText = locationManager?.parseAddress(location: locationName) {
                self.presentAlert(withTitle: "Saved", andMessage: "\(locationText) has been added to your reminder")
            }
            
            
        } else {
            self.presentAlert(withTitle: "Unable to save", andMessage: "You must select a location in order to save")
        }
        
    }
}




















