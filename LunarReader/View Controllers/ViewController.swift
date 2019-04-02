//
//  ViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/1/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController, WordBoxFinderDelegate {
    
    @IBOutlet weak var scrollView: ScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.scrollView.delegate = self.scrollView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after the view appears.
        
        let wordBoxFinder = WordBoxFinder(image: self.imageView.image!, delegate: self)
        try? wordBoxFinder.findWordBoxes()
    }
    
    func didFindWordBoxes(wordBoxes: [CGRect]) {
        // Calculate image frame and offset within image view
        let imageFrame = AVMakeRect(aspectRatio: self.imageView.image!.size, insideRect: self.imageView.bounds)
        let yOffset = 0.5 * (self.imageView.frame.size.height - imageFrame.size.height)
        
        // Draw each word box
        wordBoxes.forEach { wordBox in
            let x = wordBox.minX * imageFrame.size.width
            let y = wordBox.minY * imageFrame.size.height + yOffset
            let width = wordBox.width * imageFrame.size.width
            let height = wordBox.height * imageFrame.size.height
            
            let box = CALayer()
            box.frame = CGRect(x: x, y: y, width: width, height: height)
            box.borderWidth = 2.0
            box.borderColor = UIColor.red.cgColor
            self.imageView.layer.addSublayer(box)
        }
    }

}
