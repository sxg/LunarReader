//
//  NewPageViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/4/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class NewPageViewController: UITableViewController {
    
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

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Dynamically calculate the height for the image view's row
        if indexPath.section == 1 && indexPath.row == 0 {
            let imageViewSize = self.imageView.bounds.size
            let imageSize = self.image!.size
            return imageViewSize.width / imageSize.width * imageSize.height
        } else {
            return 44 // Default UITableViewCell height
        }
    }

}
