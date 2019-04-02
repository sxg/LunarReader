//
//  ScrollView.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/2/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Foundation

class ScrollView: UIScrollView, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
