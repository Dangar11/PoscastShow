//
//  MainTabBarController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit




class MainTabBarController: UITabBarController {
  
  var maximizedTopAnchorConstraint: NSLayoutConstraint!
  var minimizedTopAnchorConstraint: NSLayoutConstraint!
  
  let podcastPlayerView = PodcastPlayerView()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.tintColor = .red
   
    setupViewControllers()
    
    setupPlayerDetailsView()
    
  }
  
  
  @objc func minimizePlayerDetails() {
    maximizedTopAnchorConstraint.isActive = false
    minimizedTopAnchorConstraint.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      //call everytime when rearange constraints
      self.view.layoutIfNeeded()
      self.tabBar.isHidden = false
      
      self.podcastPlayerView.miniPlayerView.alpha = 1
    })
    
  }
  
  func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
    maximizedTopAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.constant = 0
    minimizedTopAnchorConstraint.isActive = false
    
    podcastPlayerView.episode = episode
    
    podcastPlayerView.playlistEpisodes = playlistEpisodes
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      //call everytime when rearange constraints
      self.view.layoutIfNeeded()
      self.tabBar.isHidden = true
      
      self.podcastPlayerView.miniPlayerView.alpha = 0
    })
  }
  
  
  //MARK: - Setup Functions
  fileprivate func setupViewControllers() {
    viewControllers = [
      generateNavController(for: SearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
      generateNavController(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
      generateNavController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
    ]
  }
  
  fileprivate func setupPlayerDetailsView() {
  
    podcastPlayerView.backgroundColor = .white
    podcastPlayerView.frame = view.frame
    view.insertSubview(podcastPlayerView, belowSubview: tabBar)
    
    // user auto layout
    podcastPlayerView.translatesAutoresizingMaskIntoConstraints = false
    
    maximizedTopAnchorConstraint = podcastPlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
    maximizedTopAnchorConstraint.isActive = true
    
    minimizedTopAnchorConstraint =  podcastPlayerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

    
    podcastPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    podcastPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    podcastPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    

    
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
