//
//  NewPageViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/4/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class NewPageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imageView.image = self.image
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        // Close this modal view controller
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
