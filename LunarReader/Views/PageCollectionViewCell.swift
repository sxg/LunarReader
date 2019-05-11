//
//  PageCollectionViewCell.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/29/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var wordBoxImageView: WordBoxImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapScrollView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.wordBoxImageView
    }
    
    // MARK: - UI Actions
    
    @objc func didDoubleTapScrollView(_ sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale == self.scrollView.maximumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
        }
    }

}
