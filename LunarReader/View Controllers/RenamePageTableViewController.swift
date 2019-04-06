//
//  RenamePageTableViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/5/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class RenamePageTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var pageNameField: UITextField!
    
    private var newPageTableViewController: NewPageTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get the current page name and activate the text field
        self.newPageTableViewController = self.navigationController!.viewControllers.reversed()[1] as? NewPageTableViewController
        self.pageNameField.text = self.newPageTableViewController?.pageNameLabel.text
        self.pageNameField.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // Set the page name on the NewPageViewController and go back to it
        self.newPageTableViewController?.pageNameLabel.text = self.pageNameField.text
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pageNameField.resignFirstResponder()
        self.didTapDoneButton(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if let emptyText = text?.isEmpty, emptyText {
            self.doneButton.isEnabled = false
        } else {
            self.doneButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.doneButton.isEnabled = false
        return true
    }

}
