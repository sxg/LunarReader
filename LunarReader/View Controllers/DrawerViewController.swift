//
//  DrawerViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/10/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Pulley

class DrawerViewController: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var filteredCollections: [Collection] = DataManager.shared.collections

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set the Pulley delegate
        self.pulleyViewController?.delegate = self
        
        // Make the background of the navigation title clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Setup the search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        // Load data
        DispatchQueue.global(qos: .background).async {
            DataManager.shared.loadCollections()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Reload the table when a new collection is saved
        NotificationCenter.default.addObserver(forName: .didSaveCollection, object: nil, queue: OperationQueue.main) { notification in
            self.tableView.reloadData()
        }
        
        // Register xib for table view
        self.tableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCell")
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching() {
            return self.filteredCollections.count
        } else {
            return DataManager.shared.collections.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell", for: indexPath) as! DrawerTableViewCell
        let collection: Collection
        if self.isSearching() {
            collection = self.filteredCollections[indexPath.row]
        } else {
            collection = DataManager.shared.collections[indexPath.row]
        }
        cell.label.text = collection.name
        cell.thumbnailView.image = UIImage(cgImage: collection.pages[0].image.cgImage!, scale: 1, orientation: .right)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = DataManager.shared.collections[indexPath.row]
        self.performSegue(withIdentifier: "DrawerDetailTableViewControllerSegue", sender: collection)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        self.filteredCollections = DataManager.shared.collections.filter { $0.name.lowercased().contains(searchText) }
        self.tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    // MARK: - PulleyDrawerViewControllerDelegate
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        let minDistance: CGFloat = bottomSafeArea + 73 // Returned by collapsedDrawerHeight()
        let maxDistance: CGFloat = 44 // Distance over which to fade the table view
        self.tableView.alpha = min((distance - minDistance) / maxDistance, 1)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let drawerDetailViewController = segue.destination as! DrawerDetailViewController
        let collection = sender as! Collection
        drawerDetailViewController.collection = collection
    }
    
    // MARK: - Helpers
    
    private func isSearchBarEmpty() -> Bool {
        return self.navigationItem.searchController!.searchBar.text?.isEmpty ?? true
    }
    
    private func isSearching() -> Bool {
        return self.navigationItem.searchController!.isActive && !self.isSearchBarEmpty()
    }

}
