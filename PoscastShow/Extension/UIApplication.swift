//
//  UIApplication.swift
//  PoscastShow
//
//  Created by Igor Tkach on 17.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


extension UIApplication {
  
  static func mainTabBarController() -> MainTabBarController? {
    
    return shared.keyWindow?.rootViewController as? MainTabBarController
  }
  
}
