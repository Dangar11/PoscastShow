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

    //if secure use regular https, if not secure replace http with http's
    let secureFeedURL = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
    
    guard let url = URL(string: secureFeedURL) else { return }
    
    let parser = FeedParser(URL: url)
    parser.parseAsync { (result) in
      switch result {
      case .failure(let error):
        print("Failed to parse RSS feed, ", error)
      case .success(let feed):
        switch feed {
        case .rss(let rss):
          guard let rssItems = rss.items else { return }
          print("RSS", rssItems.forEach { feedItem in
            let episode = Episode(title: feedItem.title ?? "")
            self.episodes.append(episode)
            })
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        default:
          print("Found a feed....")
        }
      }
    }
    
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



