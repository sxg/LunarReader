//
//  DrawerDetailViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/11/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Pulley

class DrawerDetailViewController: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var label: UILabel!
    
    var collection: Collection?
    
    private var filteredPages: [Page] = []
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title
        self.label.text = self.collection!.name
        
        // Set the filtered pages
        self.filteredPages = self.collection!.pages
        
        // Register xib for table view
        self.tableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCell")
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ? self.filteredPages.count : self.collection!.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell", for: indexPath) as! DrawerTableViewCell
        let page = self.isSearching ? self.filteredPages[indexPath.row] : self.collection!.pages[indexPath.row]
        cell.label.text = page.name
        cell.thumbnailView.image = UIImage(cgImage: page.image.cgImage!, scale: 1, orientation: .right)
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.presentingViewController!.pulleyViewController!.setDrawerPosition(position: .open, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.presentingViewController!.pulleyViewController!.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filteredPages = self.collection!.pages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            self.filteredPages = self.collection!.pages
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
