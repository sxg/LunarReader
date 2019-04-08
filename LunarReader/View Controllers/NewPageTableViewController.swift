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
    
    private var didBeginFindingWords: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the image and start finding the words
        self.wordBoxImageView.image = self.image
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
        // Save the new page and dismiss this modal view controller
        let page = Page(name: self.pageNameLabel.text!, image: self.wordBoxImageView.image!, wordBoxes: self.wordBoxImageView.wordBoxes!)
        let collection = Collection(name: self.collectionNameLabel.text!, pages: [page])
        do {
            try DataManager.save(collection: collection)
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save collection.")
        }
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
        self.wordBoxImageView.drawLines(wordBoxes: wordBoxes)
    }

}
