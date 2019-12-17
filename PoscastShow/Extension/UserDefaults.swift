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
  
  func savedPodcast() -> [Podcast] {
    guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return []}
    do {
      guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcast] else { return []}
      return savedPodcasts
    } catch let savedErrorPodcast {
      print("Unable to retrieve savedPodcasts: ", savedErrorPodcast)
    }
    return []
  }
  
  
  func deletePodcast(podcast: Podcast) {
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
  
}
