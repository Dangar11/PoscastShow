//
//  DownloadsController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 17.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class DownloadsController: UITableViewController {
  
  
  var episodes = UserDefaults.standard.downloadedEpisodes()
  
  fileprivate let cellId = "downloadsCellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupTableView()
    setupObservers()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    episodes = UserDefaults.standard.downloadedEpisodes()
    tableView.reloadData()
  }
  
  fileprivate func setupObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
  }
  
  fileprivate func setupTableView() {
    tableView.register(EpisodesCell.self, forCellReuseIdentifier: cellId)
  }
  
  @objc fileprivate func handleDownloadProgress(notification: Notification) {
    
    guard let userInfo = notification.userInfo as? [String : Any] else { return }
    guard let progress = userInfo["progress"] as? Double, let title = userInfo["title"] as? String else { return }
    
    print(title, progress)
    // lets find index using title
    guard let index = self.episodes.lastIndex(where: { $0.title == title }) else { return }
    
    guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodesCell else { return }
    cell.downloadProgressLabel.isHidden = false
    cell.downloadProgressLabel.text = "\(Int(100 * progress))%"
    
    if progress == 1.0 {
      cell.downloadProgressLabel.isHidden = true
    }
    
  }
  
  
  @objc fileprivate func handleDownloadComplete(notification: Notification) {
    
    guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadComplete else { return }
    
    guard let index = self.episodes.lastIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
    
    self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodesCell
    cell.episode = self.episodes[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let episode = self.episodes[indexPath.row]
    
    if episode.fileUrl != nil {
      UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
    } else {
      let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
      }))
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(alertController, animated: true)
    }
    
  }
  
  
  //MARK: Swipe for editing
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
      let selectedEpisode = self.episodes[indexPath.row]
      self.episodes.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      UserDefaults.standard.deleteEpisode(episode: selectedEpisode)
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
}
