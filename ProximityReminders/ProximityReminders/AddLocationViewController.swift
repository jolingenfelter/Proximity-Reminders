//
//  AddLocationViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/19/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import MapKit
import Contacts

enum ReminderType: String {
    case arrival
    case departure
}

class AddLocationViewController: UIViewController {
    
    // View Variables
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
        
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
    
    var searchLocations: [MKLocalSearchCompletion] = []
    let mapView = MKMapView()
    var locationToSave: CLLocation?
    var savedLocation: CLLocation?
    var locationManager: LocationManager?
    
    lazy var searchCompleter: MKLocalSearchCompleter = {
        
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        
        return completer
    }()
    
    // Other
    var reminderType: ReminderType?
    var searchBar: UISearchBar?
    var reminderAddress: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationManager = LocationManager()
        configureSearchController()
        
        if let savedLocation = savedLocation {
            
            let coordiante = CLLocationCoordinate2D(latitude: savedLocation.coordinate.latitude, longitude: savedLocation.coordinate.longitude)
            
            let placemark = MKPlacemark(coordinate: coordiante)
            
            searchBar!.text = reminderAddress
        
            mapView.dropPinAndZoom(placemark: placemark)
            
        } else {
            
            locationManager!.manager.startUpdatingLocation()
            
            if let managerLocation = locationManager!.manager.location {
                let span = MKCoordinateSpanMake(0.5, 0.5)
                let location = CLLocationCoordinate2DMake(managerLocation.coordinate.latitude, managerLocation.coordinate.longitude)
                let region = MKCoordinateRegionMake(location, span)
                mapView.setRegion(region, animated: true)
                mapView.showsUserLocation = true
                
                locationManager!.manager.stopUpdatingLocation()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSetup()
        searchController.loadViewIfNeeded()
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.definesPresentationContext = true
        
        reminderType = .arrival
        
    }
    
    deinit {
        searchController.loadViewIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        // SearchBar
        
        guard let searchBar = searchBar else {
            return
        }
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)])
        
        // SegmentedControl
        
        view.addSubview(notificationTimeOptionButtons)
        notificationTimeOptionButtons.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationTimeOptionButtons.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            notificationTimeOptionButtons.heightAnchor.constraint(equalToConstant: 25),
            notificationTimeOptionButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            notificationTimeOptionButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
        
        // MapView
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: notificationTimeOptionButtons.bottomAnchor, constant: 10),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        
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
        
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true, completion: nil)
        }
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        locationToSave = nil
        savedLocation = nil
        reminderType = nil
        reminderAddress = nil
        
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
        
        let location = searchLocations[indexPath.row]
        cell.textLabel?.text = location.title
        cell.detailTextLabel?.text = location.subtitle
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchController.searchBar.endEditing(true)
        tableView.isHidden = true
        
        let completedSearch = searchLocations[indexPath.row]
        
        searchController.searchBar.text = completedSearch.title
        reminderAddress = "\(completedSearch.title)"
        
        mapView.searchAndZoomInOn(searchCompletion: completedSearch, completion: { (location) in
            self.locationToSave = location
        })

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
        
        searchCompleter.queryFragment = searchText
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        if searchBar.text != nil {
            
            searchBar.text = searchLocations.first?.title
            
            guard let search = searchLocations.first else {
                return
            }
            
            reminderAddress = "\(search.title)"
            
            mapView.searchAndZoomInOn(searchCompletion: search, completion: { (location) in
                self.locationToSave = location
            })
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        searchLocations = []
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
}

// MARK: - SearchCompleterDelegate

extension AddLocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchLocations = completer.results
        tableView.reloadData()
    }
    
}

// MARK: - SegmentedControll

extension AddLocationViewController {
    
    func toggleSegmentController(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0 :
            self.reminderType = ReminderType.arrival
        
        case 1:
            self.reminderType = ReminderType.departure
            
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
        
        guard let locationToSave = locationToSave else {
            
            self.presentAlert(withTitle: "Unable to save", andMessage: "You must select a location in order to save")
            return
        }
        
        savedLocation = locationToSave
            
        self.presentAlert(withTitle: "Saved", andMessage: "\(reminderAddress!) has been added to your reminder")
        
    }
}
