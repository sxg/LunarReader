//
//  ViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/1/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, WordBoxFinderDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var wordBoxImageView: WordBoxImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after the view appears.
        
        let wordBoxFinder = WordBoxFinder(image: self.wordBoxImageView.image!, delegate: self)
        try? wordBoxFinder.findWordBoxes()
    }
    
    // MARK: - WordBoxFinder delegate
    
    func didFindWordBoxes(wordBoxFinder: WordBoxFinder, wordBoxes: [CGRect]) {
        self.wordBoxImageView.drawLines(wordBoxes: wordBoxes)
    }
    
    // MARK: - UIScrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.wordBoxImageView
    }

}
