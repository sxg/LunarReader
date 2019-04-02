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

class ViewController: UIViewController {

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
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: imageView.image!.cgImage!, options: [:])
        let textDetectionRequest = VNDetectTextRectanglesRequest { (request, err) in
            guard let observations = request.results else {
                print("no result")
                return
            }
            guard err == nil else { print(err!); return }
            
            let result = observations.map({$0 as? VNTextObservation})
            
            DispatchQueue.main.async() {
                self.imageView.layer.sublayers?.removeSubrange(1...)
                for region in result {
                    guard let rg = region else {
                        continue
                    }
                    guard let boxes = rg.characterBoxes else {
                        return
                    }
                    
                    var maxX: CGFloat = CGFloat.infinity
                    var minX: CGFloat = 0.0
                    var maxY: CGFloat = CGFloat.infinity
                    var minY: CGFloat = 0.0
                    
                    for char in boxes {
                        if char.bottomLeft.x < maxX {
                            maxX = char.bottomLeft.x
                        }
                        if char.bottomRight.x > minX {
                            minX = char.bottomRight.x
                        }
                        if char.bottomRight.y < maxY {
                            maxY = char.bottomRight.y
                        }
                        if char.topRight.y > minY {
                            minY = char.topRight.y
                        }
                    }
                    
                    let imageFrame = AVMakeRect(aspectRatio: self.imageView.image!.size, insideRect: self.imageView.bounds)
                    let yOffset = 0.5 * (self.imageView.frame.size.height - imageFrame.size.height)
                    let xCord = maxX * imageFrame.size.width
                    let yCord = (1 - minY) * imageFrame.size.height + yOffset
                    let width = (minX - maxX) * imageFrame.size.width
                    let height = (minY - maxY) * imageFrame.size.height
                    
                    let outline = CALayer()
                    outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
                    outline.borderWidth = 2.0
                    outline.borderColor = UIColor.red.cgColor
                    
                    self.imageView.layer.addSublayer(outline)
                }
            }
        }
        textDetectionRequest.reportCharacterBoxes = true
        
        do {
            try imageRequestHandler.perform([textDetectionRequest])
        } catch {
            print(error)
        }
    }

}
