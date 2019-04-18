//
//  DrawerUnwindSegue.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/16/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class DrawerUnwindSegue: UIStoryboardSegue {
    
    override func perform() {
        // Create a "curtain" view to un-dim the background
        let curtainView = UIView(frame: self.destination.view.frame)
        curtainView.backgroundColor = UIColor.darkGray
        curtainView.alpha = 0.4
        self.destination.view.addSubview(curtainView)
        self.source.view.superview?.insertSubview(self.destination.view, belowSubview: self.source.view)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.source.view.frame = CGRect(x: self.source.view.frame.minX, y: self.source.view.frame.maxY, width: self.source.view.frame.width, height: self.source.view.frame.height)
            curtainView.alpha = 0.0
        }, completion: { finished in
            curtainView.removeFromSuperview()
            self.destination.dismiss(animated: false, completion: nil)
        })
    }

}

