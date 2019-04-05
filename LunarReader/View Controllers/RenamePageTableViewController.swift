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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.pageNameField.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        // Set the page name on the NewPageViewController and go back to it
        let newPageViewController = self.navigationController!.viewControllers.reversed()[1] as! NewPageViewController
        newPageViewController.pageNameLabel.text = self.pageNameField.text
        self.navigationController?.popViewController(animated: true)
    }

}
