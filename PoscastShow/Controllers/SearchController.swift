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
    //1.register CellwCe
    tableView.register(PoscastCell.self, forCellReuseIdentifier: cellId)
    tableView.tableFooterView = UIView()
  }
  
  
  //MARK: - TableView Implementing
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PoscastCell
    let podcast = podcasts[indexPath.row]
    
    cell.podcast = podcast
    return cell
  }
  
 
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    150
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "Please enter a Search Term"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    250
  }
}


//MARK: - SearchBar respond to changes
extension SearchController: UISearchBarDelegate {
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Alamofire to search iTunes API
    

    APIService.shared.fetchPodcast(searchText: searchText) { [weak self] (podcast) in
      self?.podcasts = podcast
      self?.tableView.reloadData()
    }
    

    
  }
  
}
