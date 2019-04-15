//
//  DrawerContainerViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/15/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Pulley

class DrawerContainerViewController: UIViewController, PulleyDrawerViewControllerDelegate {
    
    // MARK: - PulleyDrawerViewControllerDelegate
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return bottomSafeArea + 73
    }

}
