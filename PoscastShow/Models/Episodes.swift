//
//  Episodes.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation
import FeedKit


struct Episode: Codable {
  let title: String
  let pubDate: Date
  let description: String
  let author: String
   let streamURL: String
  
  var imageURL: String?
 
  
  
  init(feedItem: RSSFeedItem) {
    self.streamURL = feedItem.enclosure?.attributes?.url ?? ""
    
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
    self.imageURL = feedItem.iTunes?.iTunesImage?.attributes?.href
    self.author = feedItem.iTunes?.iTunesAuthor ?? ""
  }
}
