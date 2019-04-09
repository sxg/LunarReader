//
//  ChooseCollectionTableViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/6/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ChooseCollectionTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var newPageTableViewController: NewPageTableViewController?
    private var collectionName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load data
        DispatchQueue.main.async {
            DataManager.shared.loadCollections()
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
        
        // Get reference to previous view controller
        self.newPageTableViewController = self.navigationController!.viewControllers.reversed()[1] as? NewPageTableViewController
        
        // Register xib for table view
        self.tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // Set the collection name on the NewPageViewController and go back to it
        self.newPageTableViewController?.collectionNameLabel.text = self.collectionName
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.collectionName = textField.text
        self.doneButton.isEnabled = self.doesCollectionNameExist()
        // Deselect an existion collection if the user starts typing to minimize ambiguity about the collection name
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.delegate?.tableView?(self.tableView, didDeselectRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.didTapDoneButton(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disable the "Done" button if no text is entered while the user is in the text field
        self.collectionName = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.doneButton.isEnabled = self.doesCollectionNameExist()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Disable the "Done" button if the user clears the text field
        self.collectionName = nil
        self.doneButton.isEnabled = false
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return DataManager.shared.collections.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "New Collection"
        case 1:
            return DataManager.shared.collections.count == 0 ? "" : "Collections"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.delegate = self
            cell.textField.text = self.newPageTableViewController?.collectionNameLabel.text
            cell.textField.becomeFirstResponder()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)
            cell.textLabel?.text = DataManager.shared.collections[indexPath.row].name
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            // Dismiss the keyboard and clear the text field if an existing collection is selected
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell
            cell.textField.text = nil
            cell.textField.resignFirstResponder()
            
            // Get the collection name, enable the "Done" button, and add a checkmark next to the selected cell
            let selectedCell = tableView.cellForRow(at: indexPath)
            self.collectionName = selectedCell?.textLabel?.text
            self.doneButton.isEnabled = true
            selectedCell?.accessoryType = .checkmark
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            // Remove the checkmark on deselecting a row
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        default:
            return
        }
    }
    
    // MARK: - Helpers
    
    private func doesCollectionNameExist() -> Bool {
        return self.collectionName != nil && !self.collectionName!.isEmpty
    }
    
}
