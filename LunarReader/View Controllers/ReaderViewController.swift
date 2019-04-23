//
//  ReaderViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/23/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public var page: Page?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title
        self.navigationItem.title = self.page!.name
        
        // Set the page
        self.imageView.image = self.page!.image
    }

    // MARK: - Navigation
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
