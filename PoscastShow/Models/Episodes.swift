//
//  Episodes.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation
import FeedKit


struct Episode {
  let title: String
  let pubDate: Date
  let description: String
  
  
  init(feedItem: RSSFeedItem) {
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.description ?? ""
  }
}
