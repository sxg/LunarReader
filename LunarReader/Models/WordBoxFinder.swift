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
        
    }
    
}

protocol WordBoxFinderDelegate: class {
    
    func didFindWordBoxes(wordBoxes: [CGRect])
    
}
