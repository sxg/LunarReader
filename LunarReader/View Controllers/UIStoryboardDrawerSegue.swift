//
//  UIStoryboardDrawerSegue.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/16/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class UIStoryboardDrawerSegue: UIStoryboardSegue {
    
    override func perform() {
        self.source.addChild(self.destination)
        // Set the destination view below the bottom edge of the screen
        self.destination.view.frame = CGRect(x: self.source.view.frame.minX, y: self.source.view.frame.maxY, width: self.source.view.frame.width, height: self.source.view.frame.height)
        // Create a "curtain" view to dim the background
        let curtainView = UIView(frame: self.source.view.frame)
        curtainView.backgroundColor = UIColor.darkGray
        curtainView.alpha = 0
        self.source.view.addSubview(curtainView)
        self.source.view.addSubview(self.destination.view)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.destination.view.frame = self.source.view.frame
            curtainView.alpha = 0.3
        }, completion: { finished in
            curtainView.removeFromSuperview()
        })
    }

}
