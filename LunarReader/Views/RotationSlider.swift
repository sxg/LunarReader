//
//  RotationSlider.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/25/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class RotationSlider: UIControl, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var rotationAngle: CGFloat { // radians
        get {
            return (self.scrollView.contentOffset.x - 137) / 135 * 37 / 180 * CGFloat.pi
        }
        set {
            var contentOffset = self.scrollView.contentOffset
            contentOffset.x = newValue / 37 * 180 / CGFloat.pi * 135 + 137
            self.scrollView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add observer for page changes
        NotificationCenter.default.addObserver(forName: .didChangePage, object: nil, queue: OperationQueue.main) { notification in
            let wordBoxImageView = notification.userInfo!["WordBoxImageView"] as! WordBoxImageView
            self.rotationAngle = wordBoxImageView.page!.lineRotationAngle
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.sendActions(for: .valueChanged)
    }
    
}
