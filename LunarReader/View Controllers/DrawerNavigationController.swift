//
//  DrawerNavigationController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/22/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Pulley

class DrawerNavigationController: UINavigationController, PulleyDrawerViewControllerDelegate {

    // MARK: - PulleyDrawerViewControllerDelegate
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return bottomSafeArea + 73
    }
    
}
