//
//  APIService.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
  
  let url = "https://itunes.apple.com/search"
  
  //singleton
  static let shared = APIService()
  
  
  func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
    
    //if secure use regular https, if not secure replace http with http's
    let secureFeedURL = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
    
    guard let url = URL(string: secureFeedURL) else { return }
    
    DispatchQueue.global(qos: .background).async {
      let parser = FeedParser(URL: url)
      
      parser.parseAsync { (result) in
        switch result {
        case .failure(let error):
          print("Failed to parse XML feed, ", error)
        case .success(let feed):
          switch feed {
          case .rss(let rss):
            //return from extenstion(RSSFeed)
            let episodes = rss.toEpisodes()
            completionHandler(episodes)
            
            
          default:
            print("Found a feed....")
          }
        }
      }
    }
    
  }
  
  
  
  
  func fetchPodcast(searchText: String, completionHandler: @escaping ([Results]) -> ()) {
    print("Searching for podcast...")
    
    
    
    let parameters = ["term" : searchText, "media" : "podcast"]
    
    Alamofire.request(url,
                      method: .get,
                      parameters: parameters,
                      encoding: URLEncoding.default,
                      headers: nil).responseData { (dataResponse) in
                        
                        if let error = dataResponse.error {
                          print("Failed to contact yahoo", error)
                          return
                        }
          
                        
                        guard let data = dataResponse.data else { return }
                        
                        // decode json data
                        let decoder = JSONDecoder()
                        do {
                          
                          let searchResults = try decoder.decode(SearchResults.self, from: data)
                          searchResults.results?.forEach({ (result) in
                          })
                          guard let podcastResult = searchResults.results else { return }
                          completionHandler(podcastResult)
                        } catch let error {
                          print("Failed to Decode: ", error.localizedDescription)
                        }
                        
    }

  }
  
  
}

