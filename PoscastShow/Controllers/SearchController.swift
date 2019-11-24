//
//  SearchController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 24.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class SearchController: UITableViewController {
  
  
  let cellId = "searchCell"
  
  let podcasts = [
    Podcast(name: "Jimmy", artistName: "Brian Vong"),
    Podcast(name: "Braid Pitt", artistName: "Jonny Cash"),
    Podcast(name: "English in 10 Seconds", artistName: "VenyaTV")
  ]
  
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
    cell.textLabel?.text = """
    Podcast: \(podcasts[indexPath.row].name)
    Author: \(podcasts[indexPath.row].artistName)
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
  }
  
}
