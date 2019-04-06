//
//  ChooseCollectionTableViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/6/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ChooseCollectionTableViewController: UITableViewController {

    @IBOutlet weak var collectionNameField: UITextField!
    
    private var newPageTableViewController: NewPageTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get the current page name and activate the text field
        self.newPageTableViewController = self.navigationController!.viewControllers.reversed()[1] as? NewPageTableViewController
        self.collectionNameField.text = self.newPageTableViewController?.collectionNameLabel.text
        self.collectionNameField.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        // Set the page name on the NewPageViewController and go back to it
        self.newPageTableViewController?.collectionNameLabel.text = self.collectionNameField.text
        self.navigationController?.popViewController(animated: true)
    }

}
