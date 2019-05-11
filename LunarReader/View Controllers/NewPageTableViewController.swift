//
//  NewPageTableViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/4/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class NewPageTableViewController: UITableViewController, WordBoxFinderDelegate {
    
    @IBOutlet weak var wordBoxImageView: WordBoxImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var pageNameLabel: UILabel!
    
    public var image: UIImage?
    public var collection: Collection?
    
    private var didBeginFindingWords: Bool = false
    private var wordBoxes: [CGRect]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the image and start finding the words
        self.wordBoxImageView.image = self.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup before the view appears
        
        // Update the collection name label
        if let name = self.collection?.name {
            self.collectionNameLabel.text = name
        } else {
            self.collectionNameLabel.text = "My collection"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after the view appears.
        
        guard self.didBeginFindingWords == false else { return }
        
        let wordBoxFinder = WordBoxFinder(image: self.image!, delegate: self)
        self.didBeginFindingWords = true
        try? wordBoxFinder.findWordBoxes() // TODO: Improve error handling
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        // Close this modal view controller
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        // Create the new page
        let page = Page(name: self.pageNameLabel.text!, image: self.wordBoxImageView.image!, wordBoxes: self.wordBoxes!)
        
        // Add the collection
        DataManager.shared.add(page: page, to: self.collection!, completionHandler: { result in
            switch result {
            case .success(()):
                return
            case .failure(let error):
                print("Failed to add page to collection: \(page) \(self.collection!)")
                print("Error: \(error)")
            }
        })

        // Dismiss the view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Dynamically calculate the height for the image view's row
        if indexPath.section == 1 && indexPath.row == 0 {
            let imageViewSize = self.wordBoxImageView.bounds.size
            let imageSize = self.image!.size
            return imageViewSize.width / imageSize.width * imageSize.height
        } else {
            return 44 // Default UITableViewCell height
        }
    }
    
    // MARK: - WordBoxFinderDelegate
    
    func didFindWordBoxes(wordBoxFinder: WordBoxFinder, wordBoxes: [CGRect]) {
        self.wordBoxes = wordBoxes
        self.wordBoxImageView.drawLines(wordBoxes: wordBoxes, lineWidth: 1.0, lineColor: .black, lineRotationAngle: 0)
    }

}
