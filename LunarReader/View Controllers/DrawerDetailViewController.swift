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
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let page: Page
        if self.isSearching {
            page = self.filteredPages[indexPath.row]
            self.searchBar.resignFirstResponder()
            self.pulleyViewController!.setDrawerPosition(position: .open, animated: true)
        } else {
            page = self.collection!.pages[indexPath.row]
        }
        self.performSegue(withIdentifier: "ReaderSegue", sender: page)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            return
        case .insert:
            return
        case .delete:
            let page = self.collection!.pages[indexPath.row]
            DataManager.shared.remove(page: page, from: self.collection!) { result in
                switch result {
                case .success(()):
                    return
                case .failure(let error):
                    print("Failed to delete page in collection: \(page) \(self.collection!)")
                    print("Error: \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.navigationController!.pulleyViewController!.setDrawerPosition(position: .open, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.navigationController!.pulleyViewController!.setDrawerPosition(position: .partiallyRevealed, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReaderSegue" {
            let readerViewController = (segue.destination as! UINavigationController).topViewController as! ReaderViewController
            let page = sender as! Page
            readerViewController.collection = self.collection!
            readerViewController.currentIndex = self.collection!.pages.firstIndex(where: { $0 == page }) ?? 0
        }
    }

}
