//
//  RotationSliderView.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/25/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class RotationSliderView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var rotationAngle: CGFloat {
        get {
            return (self.scrollView.contentOffset.x - 135) / 135 * 37
        }
    }
    
}
