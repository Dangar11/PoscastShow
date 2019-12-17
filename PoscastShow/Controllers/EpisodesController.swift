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
  
  
  var podcast: Podcast? {
    
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
    setupNavigationBarButtons()
 
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
  
  fileprivate func setupNavigationBarButtons() {
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleFavorite)),
      UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcast))
    ]
    
  }
  
  
   @objc fileprivate func handleFetchSavedPodcast() {
    print("fetching from user deefaults")
    guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return }
    do {
       let podcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
      
      podcast?.forEach({ (podcastIn) in
        print(podcastIn.collectionName, podcastIn.artistName)
      })
//      print(podcast?.collectionName, podcast?.artistName)
    } catch let errorUnarchiver {
      print("Failed to unarchive data ", errorUnarchiver)
    }
   
    
  }
  
  
  @objc fileprivate func handleFavorite() {
    print("Saving into userDefaults")
    
    guard let podcast = self.podcast else { return }
    
    var listOfPodcast = [Podcast]()
    
    //1. Fetch podcast
    listOfPodcast = UserDefaults.standard.savedPodcast()
    
    
    // 2. Transform podcast into Data
    do {
      
      listOfPodcast.append(podcast)
      let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
      UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
    } catch let errorData {
      print("Failed to transform custom struct into data: ", errorData)
    }
   
    
    
  }
  
  
  
    
  
  
  //MARK: - Setup View
  
  fileprivate func setupTableView() {
    tableView.register(EpisodesCell.self, forCellReuseIdentifier: cellId)
     //remove unnecessary lines
     tableView.tableFooterView = UIView()
    
  }
  
  
  
  //MARK: - UITableView
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return episodes.isEmpty ? 200 : 0
  }
  
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let activityIndicatiorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    activityIndicatiorView.color = .darkGray
    activityIndicatiorView.startAnimating()
    return activityIndicatiorView
  }
  
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
    
    

  }
  
  
  
  
}



