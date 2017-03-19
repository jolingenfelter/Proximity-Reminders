//
//  AddLocationViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/19/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        return tableView
    }()
    
    lazy var notificationTimeOptionButtons: UISegmentedControl = {
        
        let items = ["On arrival", "On departure"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(toggleSegmentController(sender:)), for: .valueChanged)
        
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSetup()
    }
    
    override func viewDidLayoutSubviews() {
        
        // TableView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: UITableViewDelegate 

extension AddLocationViewController: UITableViewDelegate {
    
}

// MARK: UISearchController

extension AddLocationViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

// MARK: - SegmentedControll

extension AddLocationViewController {
    
    func toggleSegmentController(sender: UISegmentedControl) {
        
    }
    
}

// MARK: NavigationBar

extension AddLocationViewController {
    
    func navigationBarSetup() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        let saveLocationButton = UIBarButtonItem(title: "Save Location", style: .plain, target: self, action: #selector(saveLocationPressed))
        navigationItem.rightBarButtonItem = saveLocationButton
        
    }
    
    func saveLocationPressed() {
        
    }
    
}
