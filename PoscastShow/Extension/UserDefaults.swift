//
//  UserDefault.swift
//  PoscastShow
//
//  Created by Igor Tkach on 16.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation


extension UserDefaults {
  
  static let favoritePodcastKey = "favoritePoscastKey"
  static let downloadedEpisodeKey = "downloadedEpisodeKey"
  
  func savedPodcast() -> [Podcasts] {
    guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return []}
    do {
      guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcasts] else { return []}
      return savedPodcasts
    } catch let savedErrorPodcast {
      print("Unable to retrieve savedPodcasts: ", savedErrorPodcast)
    }
    return []
  }
  
  
  func deletePodcast(podcast: Podcasts) {
    let podcasts = savedPodcast()
    //filter all by compare with json initial data
    let filteredPodcasts = podcasts.filter { (p) -> Bool in
      return p.collectionName != podcast.collectionName && p.artistName != podcast.artistName
    }
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
    } catch let errorArchive {
      print("Unable to Archive deletedPodcast: ", errorArchive)
    }
  
  }
  
  
  
  func downloadEpisode(episode: Episode) {
    
    do {
      var episodes = downloadedEpisodes()
      episodes.insert(episode, at: 0)
      let data = try JSONEncoder().encode(episodes)
      UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
    } catch let encoderError {
      print("Failed encode Episode for download: ", encoderError)
    }
  }
  
  func downloadedEpisodes() -> [Episode] {
    guard let episodesData = data(forKey: UserDefaults.downloadedEpisodeKey) else { return []}
    
    
    do {
      let decodeEpisode = try JSONDecoder().decode([Episode].self, from: episodesData)
      return decodeEpisode
    } catch let decodeError {
      print("Failed to decode Downloads Episodes: ", decodeError)
    }
    return []
  }
  
  
  func deleteEpisode(episode: Episode) {
    let episodes = downloadedEpisodes()
    let filteredEpisodes = episodes.filter { (ep) -> Bool in
      return ep.title != episode.title
    }
    do {
      let data = try JSONEncoder().encode(filteredEpisodes)
      UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
    } catch let deleteError {
      print("Failed to delete Donwload Episodes: ", deleteError)
    }
    
  }
  
  
  
}
