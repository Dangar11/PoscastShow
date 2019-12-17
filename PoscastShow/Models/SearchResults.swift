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
  let results: [Podcasts]?
}


