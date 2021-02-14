//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by pangborn on 7/2/20.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit


extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
