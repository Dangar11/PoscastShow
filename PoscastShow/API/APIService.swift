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
  
  
  typealias EpisodeDownloadComplete = (fileUrl: String, episodeTitle: String)
  
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
  
  
  
  
  func fetchPodcast(searchText: String, completionHandler: @escaping ([Podcasts]) -> ()) {
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
  
  
  func downloadsEpisode(episode: Episode) {
    print("Download episode using Alamofire at stream: ", episode.streamURL)
    
    //filemanager
    let downloadRequest = DownloadRequest.suggestedDownloadDestination()
    
    Alamofire.download(episode.streamURL, to: downloadRequest).downloadProgress { (progress) in
      print(progress.fractionCompleted)
      //Download Progress notify DownloadsController to download progress
      
      NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title" : episode.title, "progress" : progress.fractionCompleted])
      
      
    }.response { (response) in
      print(response.destinationURL?.absoluteString ?? "")
      
      // Notification 
      let episodeDownloadComplete = EpisodeDownloadComplete(fileUrl: response.destinationURL?.absoluteString ?? "", episode.title)
      NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
      
      //update UserDefaults donwload episodes with temp file
      //take fetch Episodes
      var downloadEpisodes = UserDefaults.standard.downloadedEpisodes()
      //Get index of current episode
      guard let index = downloadEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
      //fullfill the index fileUrl with absolute url from FileManager url
      downloadEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""
      
      do {
        let data = try JSONEncoder().encode(downloadEpisodes)
        //write this url into UserDefaults
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
      } catch let err {
        print("Failed to encode downloaded with file url update: ", err)
      }
      
      
    }
    
  }
  
  
}

