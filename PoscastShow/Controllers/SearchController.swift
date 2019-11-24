//
//  SearchController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Alamofire


class SearchController: UITableViewController {
  
  
  let cellId = "searchCell"
  
  var podcasts = [Results]()
  
  // UISearchController
  
  let searchController = UISearchController(searchResultsController: nil)
  
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  
    setupSearchBar()
    setupTableView()
  }
  
  
  //MARK: - Helper
  //MARK: Setup SeachBar
  fileprivate func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
  }
  
  //MARK: Setup TableView
  fileprivate func setupTableView() {
    //1.register Cell
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  
  //MARK: - TableView Implementing
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let podcast = podcasts[indexPath.row]
    guard let collectionName = podcast.collectionName, let artistName = podcast.artistName else { return UITableViewCell() }
    cell.textLabel?.text = """
    Podcast: \(collectionName)
    Author: \(artistName)
    """
    cell.textLabel?.numberOfLines = 0
    cell.imageView?.image = #imageLiteral(resourceName: "appicon")
    return cell
  }
  
 
  
  
  
}


//MARK: - SearchBar respond to changes
extension SearchController: UISearchBarDelegate {
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    // Alamofire to search iTunes API
    
    let url = "https://itunes.apple.com/search"
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
        self.podcasts = podcastResult
        self.tableView.reloadData()
      } catch let error {
        print("Failed to Decode: ", error.localizedDescription)
      }
      
      
    }
  }
  
}
