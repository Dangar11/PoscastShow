//
//  SearchResults.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation


struct SearchResults: Decodable {
  let resultCount: Int
  let results: [Podcast]?
}

class Podcast: NSObject, Decodable, NSCoding, NSKeyedUnarchiverDelegate, NSSecureCoding {
  
  //BUG FIX for securityCoding needed to Unerchive from Classes in iOS 13
  static var supportsSecureCoding = true
  
  
  
  let trackNameKey = "trackNameKey"
  let artistNameKey = "artistNameKey"
  let artworkKey = "artworkKey"
  
  func encode(with coder: NSCoder) {
    print("Trying to transform Podcast into Data")
    coder.encode(collectionName ?? "", forKey: trackNameKey)
    coder.encode(artistName ?? "", forKey: artistNameKey)
    coder.encode(artworkUrl600 ?? "", forKey: artworkKey)
  }
  
  required init?(coder: NSCoder) {
    print("Trying to turn Data into Podcast")
    self.collectionName = coder.decodeObject(forKey: trackNameKey) as? String
    self.artistName = coder.decodeObject(forKey: artistNameKey) as? String
    self.artworkUrl600 = coder.decodeObject(forKey: artworkKey) as? String
  }
  

  
  var collectionName: String?
  var artworkUrl600: String?
  var artistName: String?
  var trackCount: Int?
  var feedUrl: String?
}
