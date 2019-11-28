//
//  RSSFeed.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import FeedKit


extension RSSFeed {
  
  func toEpisodes() -> [Episode] {
    
    guard let rssItems = items, let imageURL = iTunes?.iTunesImage?.attributes?.href else { return []}
    
    var episodes = [Episode]()
    
    rssItems.forEach { feedItem in
      var episode = Episode(feedItem: feedItem)
      //if imageURL doesn't have an image than use it from podcastImage
      if episode.imageURL == nil {
        episode.imageURL = imageURL
      }
      episodes.append(episode)
      }
    
    return episodes
  }
  
}
