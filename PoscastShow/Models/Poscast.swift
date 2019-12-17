//
//  Poscast.swift
//  PoscastShow
//
//  Created by Igor Tkach on 17.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation


class Podcasts: NSObject, Decodable, NSCoding, NSKeyedUnarchiverDelegate, NSSecureCoding {
  
  //BUG FIX for securityCoding needed to Unerchive from Classes in iOS 13
  static var supportsSecureCoding = true
  
  
  
  let trackNameKey = "trackNameKey"
  let artistNameKey = "artistNameKey"
  let artworkKey = "artworkKey"
  let feedKey = "feedKey"
  
  func encode(with coder: NSCoder) {
    print("Trying to transform Podcast into Data")
    coder.encode(collectionName ?? "", forKey: trackNameKey)
    coder.encode(artistName ?? "", forKey: artistNameKey)
    coder.encode(artworkUrl600 ?? "", forKey: artworkKey)
    coder.encode(feedUrl ?? "", forKey: feedKey)
  }
  
  required init?(coder: NSCoder) {
    print("Trying to turn Data into Podcast")
    self.collectionName = coder.decodeObject(forKey: trackNameKey) as? String
    self.artistName = coder.decodeObject(forKey: artistNameKey) as? String
    self.artworkUrl600 = coder.decodeObject(forKey: artworkKey) as? String
    self.feedUrl = coder.decodeObject(forKey: feedKey) as? String
  }
  

  
  var collectionName: String?
  var artworkUrl600: String?
  var artistName: String?
  var trackCount: Int?
  var feedUrl: String?
}
