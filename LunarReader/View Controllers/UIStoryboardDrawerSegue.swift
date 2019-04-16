//
//  UIStoryboardDrawerSegue.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/16/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class UIStoryboardDrawerSegue: UIStoryboardSegue {
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        self.source.addChild(self.destination)
        self.destination.view.frame = CGRect(x: self.source.view.frame.minX, y: self.source.view.frame.maxY, width: self.source.view.frame.width, height: self.source.view.frame.height)
        let curtainView = UIView(frame: self.source.view.frame)
        curtainView.backgroundColor = UIColor.darkGray
        curtainView.alpha = 0
        self.source.view.addSubview(curtainView)
        self.source.view.addSubview(self.destination.view)
        
        UIView.animate(withDuration: 0.4) {
            self.destination.view.frame = self.source.view.frame
            curtainView.alpha = 0.3
        }
    }

}
