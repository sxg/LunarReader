//
//  WordBoxImageView.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/2/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class WordBoxImageView: UIImageView {
    
    var wordBoxes: [CGRect]?
    
    func drawLines(wordBoxes: [CGRect]) {
        self.wordBoxes = wordBoxes
        
        // Calculate image frame and offset within image view
        let imageFrame = AVMakeRect(aspectRatio: self.image!.size, insideRect: self.bounds)
        let yOffset = 0.5 * (self.frame.size.height - imageFrame.size.height)
        
        // Draw each word box's lines
        wordBoxes.forEach { wordBox in
            // Scale the word box to the image view and calculate line offsets
            let x = wordBox.minX * imageFrame.size.width
            let y = wordBox.minY * imageFrame.size.height + yOffset
            let width = wordBox.width * imageFrame.size.width
            let height = wordBox.height * imageFrame.size.height
            let scaledWordBox = CGRect(x: x, y: y, width: width, height: height)
            let topOffset = scaledWordBox.height * 0.6
            let bottomOffset = scaledWordBox.height * 0.4
            
            // Calculate start and end points for each line
            let topLineStart = CGPoint(x: scaledWordBox.minX, y: scaledWordBox.maxY - topOffset)
            let topLineEnd = CGPoint(x: scaledWordBox.maxX, y: scaledWordBox.maxY - topOffset)
            let bottomLineStart = CGPoint(x: scaledWordBox.minX, y: scaledWordBox.maxY - bottomOffset)
            let bottomLineEnd = CGPoint(x: scaledWordBox.maxX, y: scaledWordBox.maxY - bottomOffset)
            
            // Draw each line
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
            self.layer.addSublayer(topLine)
            self.layer.addSublayer(bottomLine)
        }
    }
    
}
