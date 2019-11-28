//
//  EpisodesController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import FeedKit


class EpisodesController: UITableViewController {
  
  
  var podcast: Results? {
    
    didSet {
      navigationItem.title = podcast?.collectionName
      fetchEpisodes()
    }
    
  }
  
  var episodes =  [Episode]()
  
  fileprivate let cellId = "episodesCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
 
  }
  
  func fetchEpisodes() {
    print("Looking for episodes at feed url:", podcast?.feedUrl ?? "" )
    
    guard let feedUrl = podcast?.feedUrl else { return }

    APIService.shared.fetchEpisodes(feedUrl: feedUrl) { [weak self] (episodes) in
      self?.episodes = episodes
      
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
    
  
  
  //MARK: - Setup View
  
  fileprivate func setupTableView() {
    tableView.register(EpisodesCell.self, forCellReuseIdentifier: cellId)
     //remove unnecessary lines
     tableView.tableFooterView = UIView()
    
  }
  
  
  
  //MARK: - UITableView
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodesCell
    let episode = episodes[indexPath.row]
    cell.episode = episode
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
}



