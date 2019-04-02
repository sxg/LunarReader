//
//  WordBoxFinder.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/2/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Foundation
import Vision

class WordBoxFinder: NSObject {
    
    weak var delegate: WordBoxFinderDelegate?
    let requestHandler: VNImageRequestHandler
    
    init(image: UIImage, delegate: WordBoxFinderDelegate) {
        self.requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        self.delegate = delegate
    }
    
    func findWordBoxes() throws {
        let request = VNDetectTextRectanglesRequest(completionHandler: self.detectTextRectanglesHandler)
        request.reportCharacterBoxes = true
        do {
            try self.requestHandler.perform([request])
        } catch {
            throw error
        }
    }
    
    private func detectTextRectanglesHandler(request: VNRequest, error: Error?) {
        guard error == nil else { print(error!); return }
        guard let results = request.results else { print("No results"); return } // TODO: Improve error handling
        
        // Map results to word boxes
        let wordBoxes = results.map { result -> CGRect in
            guard let textObservation = result as? VNTextObservation else { return CGRect.null }
            guard let characterBoxes = textObservation.characterBoxes else { return CGRect.null }
            
            // Find word box from character boxes
            var minX = CGFloat.infinity, minY = CGFloat.infinity
            var maxX = CGFloat.zero, maxY = CGFloat.zero
            for characterBox in characterBoxes {
                minX = CGFloat.minimum(minX, characterBox.bottomLeft.x)
                maxX = CGFloat.maximum(maxX, characterBox.bottomRight.x)
                minY = CGFloat.minimum(minY, characterBox.bottomLeft.y)
                maxY = CGFloat.maximum(maxY, characterBox.topLeft.y)
            }
            
            let x = maxX
            let y = 1 - minY
            let width = maxX - minX
            let height = maxY - minY
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        // Call the delegate
        self.delegate?.didFindWordBoxes(wordBoxes: wordBoxes)
    }
    
}

protocol WordBoxFinderDelegate: class {
    
    func didFindWordBoxes(wordBoxes: [CGRect])
    
}
