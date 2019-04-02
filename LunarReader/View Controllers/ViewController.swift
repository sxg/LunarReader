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

class ViewController: UIViewController, WordBoxFinderDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            let scaledWordBox = CGRect(x: x, y: y, width: width, height: height)
            let topOffset = scaledWordBox.height * 0.6
            let bottomOffset = scaledWordBox.height * 0.4
            
            let topLineStart = CGPoint(x: scaledWordBox.minX, y: scaledWordBox.maxY - topOffset)
            let topLineEnd = CGPoint(x: scaledWordBox.maxX, y: scaledWordBox.maxY - topOffset)
            let bottomLineStart = CGPoint(x: scaledWordBox.minX, y: scaledWordBox.maxY - bottomOffset)
            let bottomLineEnd = CGPoint(x: scaledWordBox.maxX, y: scaledWordBox.maxY - bottomOffset)

            let topLinePath = UIBezierPath()
            topLinePath.move(to: topLineStart)
            topLinePath.addLine(to: topLineEnd)
            let bottomLinePath = UIBezierPath()
            bottomLinePath.move(to: bottomLineStart)
            bottomLinePath.addLine(to: bottomLineEnd)
            let topLine = CAShapeLayer()
            topLine.path = topLinePath.cgPath
            topLine.fillColor = nil
            topLine.strokeColor = UIColor.black.cgColor
            topLine.lineWidth = 0.7
            topLine.lineCap = .round
            let bottomLine = CAShapeLayer()
            bottomLine.path = bottomLinePath.cgPath
            bottomLine.fillColor = nil
            bottomLine.strokeColor = UIColor.black.cgColor
            bottomLine.lineWidth = 0.7
            bottomLine.lineCap = .round
            self.imageView.layer.addSublayer(topLine)
            self.imageView.layer.addSublayer(bottomLine)
        }
    }
    
    // MARK: - UIScrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
