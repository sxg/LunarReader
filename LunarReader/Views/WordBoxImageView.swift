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
    
    var page: Page? {
        didSet {
            self.image = self.page!.image
            self.drawLines(wordBoxes: self.page!.wordBoxes, lineWidth: self.page!.lineWidth, lineColor: self.page!.lineColor, lineRotationAngle: self.page!.lineRotationAngle)
        }
    }
    
    func drawLines(wordBoxes: [CGRect], lineWidth: CGFloat, lineColor: LineColor, lineRotationAngle: CGFloat) {
        // Remove previous lines
        self.layer.sublayers?.removeAll()
        
        // Calculate image frame and offset within image view
        let imageFrame = AVMakeRect(aspectRatio: self.image!.size, insideRect: self.bounds)
        let yOffset = 0.5 * (self.bounds.size.height - imageFrame.size.height)
        
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
            topLinePath.move(to: CGPoint(x: 0, y: 0.5 * lineWidth))
            topLinePath.addLine(to: CGPoint(x: topLineEnd.x - topLineStart.x, y: 0.5 * lineWidth))
            let bottomLinePath = UIBezierPath()
            bottomLinePath.move(to: CGPoint(x: 0, y: 0.5 * lineWidth))
            bottomLinePath.addLine(to: CGPoint(x: bottomLineEnd.x - bottomLineStart.x, y: 0.5 * lineWidth))
            let topLine = CAShapeLayer()
            topLine.frame = CGRect(x: topLineStart.x, y: topLineStart.y - 0.5 * lineWidth, width: topLineEnd.x - topLineStart.x, height: lineWidth)
            topLine.path = topLinePath.cgPath
            topLine.fillColor = nil
            topLine.strokeColor = lineColor.uiColor().cgColor
            topLine.lineWidth = lineWidth
            topLine.lineCap = .round
            topLine.setAffineTransform(CGAffineTransform(rotationAngle: -lineRotationAngle))
            let bottomLine = CAShapeLayer()
            bottomLine.frame = CGRect(x: bottomLineStart.x, y: bottomLineStart.y - 0.5 * lineWidth, width: bottomLineEnd.x - bottomLineStart.x, height: lineWidth)
            bottomLine.path = bottomLinePath.cgPath
            bottomLine.fillColor = nil
            bottomLine.strokeColor = lineColor.uiColor().cgColor
            bottomLine.lineWidth = lineWidth
            bottomLine.lineCap = .round
            bottomLine.setAffineTransform(CGAffineTransform(rotationAngle: -lineRotationAngle))
            self.layer.addSublayer(topLine)
            self.layer.addSublayer(bottomLine)
        }
    }
    
}
