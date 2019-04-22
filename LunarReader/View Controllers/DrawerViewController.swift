//
//  DrawerViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/10/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Pulley

class DrawerViewController: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var filteredCollections: [Collection] = DataManager.shared.collections
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data
        DispatchQueue.global(qos: .background).async {
            DataManager.shared.loadCollections()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Set the Pulley delegate
        self.pulleyViewController!.delegate = self
        
        // Reload the table when a new collection is saved
        NotificationCenter.default.addObserver(forName: .didSaveCollection, object: nil, queue: OperationQueue.main) { notification in
            self.tableView.reloadData()
        }
        
        // Register xib for table view
        self.tableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set the Pulley delegate
        self.pulleyViewController!.delegate = self
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ? self.filteredCollections.count : DataManager.shared.collections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell", for: indexPath) as! DrawerTableViewCell
        let collection = self.isSearching ? self.filteredCollections[indexPath.row] : DataManager.shared.collections[indexPath.row]
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
        tableView.deselectRow(at: indexPath, animated: true)
        let collection: Collection
        if self.isSearching {
            collection = self.filteredCollections[indexPath.row]
            self.searchBar.resignFirstResponder()
            self.pulleyViewController!.setDrawerPosition(position: .open, animated: true)
        } else {
            collection = DataManager.shared.collections[indexPath.row]
        }
        self.performSegue(withIdentifier: "DrawerSegue", sender: collection)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filteredCollections = DataManager.shared.collections.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            self.filteredCollections = DataManager.shared.collections
        }
        self.tableView.reloadData()
    }
    
    // MARK: - PulleyDrawerViewControllerDelegate
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        // Fade the table view when the drawer collapses
        let minDistance: CGFloat = bottomSafeArea + 73 // Returned by collapsedDrawerHeight()
        let maxDistance: CGFloat = 44 // Distance over which to fade the table view
        self.tableView.alpha = min((distance - minDistance) / maxDistance, 1)
    }

    // MARK: - Navigation
    
    @IBAction func dismissDrawerDetailViewController(_ sender: UIStoryboardSegue) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrawerSegue" {
            let drawerDetailViewController = segue.destination as! DrawerDetailViewController
            let collection = sender as! Collection
            drawerDetailViewController.collection = collection
        }
    }

}
