//
//  EpisodesController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class EpisodesController: UITableViewController {
  
  
  var podcast: Results? {
    
    didSet {
      navigationItem.title = podcast?.collectionName
    }
    
  }
  
  var episodes =  [
  
  Episode(title: "Episode One: Pilit"),
    Episode(title: "Second Episode"),
    Episode(title: "Third Episode")
  ]
  
  fileprivate let cellId = "episodesCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
 
  }
  
  //MARK: - Setup View
  
  fileprivate func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
     //remove unnecessary lines
     tableView.tableFooterView = UIView()
    
  }
  
  
  
  //MARK: - UITableView
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let episode = episodes[indexPath.row]
    cell.textLabel?.text = episode.title
    return cell
  }
  
}



