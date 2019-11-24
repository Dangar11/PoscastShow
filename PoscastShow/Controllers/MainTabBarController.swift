//
//  MainTabBarController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit




class MainTapBarController: UITabBarController {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.tintColor = .red
   
    setupViewControllers()
    
  }
  
  
  //MARK: - Setup Functions
  fileprivate func setupViewControllers() {
    viewControllers = [
      generateNavController(for: SearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
      generateNavController(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
      generateNavController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
    ]
  }
  
  
  //MARK: - Helper Function
  fileprivate func generateNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
    
    let navController = UINavigationController(rootViewController: rootViewController)
    rootViewController.navigationItem.title = title
    navController.navigationBar.prefersLargeTitles = true
    navController.tabBarItem.title = title
    navController.tabBarItem.image = image
    return navController
    
  }
  
  
}
