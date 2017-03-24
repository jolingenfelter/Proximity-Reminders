//
//  AddLocationViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/19/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import MapKit

enum ReminderType: Int {
    case Arrival = 1
    case Departure = 2
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
    
    // Other
    var reminderType: ReminderType?

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
        
        // TableView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: notificationTimeOptionButtons.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        mapView.removeFromSuperview()
        tableView.removeFromSuperview()
        notificationTimeOptionButtons.removeFromSuperview()
        
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
        
        let selectedLocation = searchLocations[indexPath.row].placemark
        locationManager?.dropPinAndZoom(mapView: self.mapView, placemark: selectedLocation)
        
        locationToSave = CLLocation(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude)
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
        
        tableView.tableHeaderView = searchController.searchBar
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationSaved"), object: nil)
            
            let alert = UIAlertController(title: "Saved", message: "Selected location has been added to your reminder", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) in
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(okAction)
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Unable to save location", message: "You must select a location in order to save", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) in
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(okAction)
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}




















