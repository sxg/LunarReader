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
    private var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get reference to previous view controller
        self.newPageTableViewController = self.navigationController?.viewControllers.reversed()[1] as? NewPageTableViewController
        
        self.doneButton.isEnabled = false
        
        // Register xib for table view
        self.tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // If the text field is active, then clear the old collection and dismiss the keyboard
        if let isEditing = self.textField?.isEditing, isEditing {
            self.newPageTableViewController?.collection = nil
            self.textField?.resignFirstResponder()
        }
        
        // Create a collection and go back to the NewPageViewController
        if self.newPageTableViewController?.collection == nil {
            self.newPageTableViewController?.collection = Collection(name: self.textField!.text!, pages: [])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.doneButton.isEnabled = self.isTextFieldValid()
        // Deselect an existion collection if the user starts typing to minimize ambiguity about the collection name
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.delegate?.tableView?(self.tableView, didDeselectRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.didTapDoneButton(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disable the "Done" button if no text is entered while the user is in the text field
        self.doneButton.isEnabled = self.isTextFieldValid()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Disable the "Done" button if the user clears the text field
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
            self.textField = cell.textField
            self.textField?.delegate = self
            // If a collection has been selected and isn't an existing collection, then put the name in the text field and activate it
            if let collection = self.newPageTableViewController?.collection, !DataManager.shared.collections.contains(where: {$0.uuid == collection.uuid}) {
                self.textField?.text = collection.name
                self.textField?.becomeFirstResponder()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)
            let rowCollection = DataManager.shared.collections[indexPath.row]
            cell.textLabel?.text = rowCollection.name
            // If this collection is the selected one (if it exists), then select it and put a checkmark next to it
            if rowCollection.uuid == self.newPageTableViewController?.collection?.uuid {
                self.doneButton.isEnabled = true
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                cell.accessoryType = .checkmark
            }
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
            self.textField?.text = nil
            self.textField?.resignFirstResponder()
            
            // Get the collection, enable the "Done" button, and add a checkmark next to the selected cell
            self.newPageTableViewController?.collection = DataManager.shared.collections[indexPath.row]
            self.doneButton.isEnabled = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
    
    private func isTextFieldValid() -> Bool {
        return self.textField?.text != nil && !(self.textField?.text!.isEmpty)!
    }
    
}
