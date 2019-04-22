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
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        let minDistance: CGFloat = bottomSafeArea + 73 // Returned by collapsedDrawerHeight()
        let maxDistance: CGFloat = 44 // Distance over which to fade the table view
        let tableView: UITableView?
        switch self.topViewController! {
        case is DrawerViewController:
            tableView = (self.topViewController! as! DrawerViewController).tableView
        case is DrawerDetailViewController:
            tableView = (self.topViewController as! DrawerDetailViewController).tableView
        default:
            tableView = nil
        }
        tableView?.alpha = min((distance - minDistance) / maxDistance, 1)
    }
    
    func drawerPositionWillChange(drawer: PulleyViewController, to position: PulleyPosition, bottomSafeArea: CGFloat) {
        // Dismiss the keyboard when the drawer is collapsing
        if position != .open {
            self.view.endEditing(true)
        }
    }
    
}
