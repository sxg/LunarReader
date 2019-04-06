//
//  RenamePageTableViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/5/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class RenamePageTableViewController: UITableViewController {

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
    
    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        // Set the page name on the NewPageViewController and go back to it
        self.newPageTableViewController?.pageNameLabel.text = self.pageNameField.text
        self.navigationController?.popViewController(animated: true)
    }

}
