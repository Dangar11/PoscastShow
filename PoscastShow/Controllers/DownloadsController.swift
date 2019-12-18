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
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    episodes = UserDefaults.standard.downloadedEpisodes()
    tableView.reloadData()
  }
  
  
  
  fileprivate func setupTableView() {
    tableView.register(EpisodesCell.self, forCellReuseIdentifier: cellId)
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
    print("Launch episode player")
    let episode = self.episodes[indexPath.row]
    
    if episode.fileUrl != nil {
      
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
