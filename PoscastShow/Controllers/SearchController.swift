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
  
  //search delay
  var timer: Timer?
  // UISearchController
  
  let searchController = UISearchController(searchResultsController: nil)
  
  //MARK: - View Lifecicle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  
    setupSearchBar()
    setupTableView()
    
    searchBar(searchController.searchBar, textDidChange: "Voong")
  }
  
  
  //MARK: - Helper
  //MARK: Setup SeachBar
  fileprivate func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
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
    podcasts.count > 0 ? 0 : 250
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let episodesController = EpisodesController()
    let podcast = podcasts[indexPath.row]
    episodesController.podcast = podcast
    navigationController?.pushViewController(episodesController, animated: true)
  }
  
  
}


//MARK: - SearchBar respond to changes
extension SearchController: UISearchBarDelegate {
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Alamofire to search iTunes API
    
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      APIService.shared.fetchPodcast(searchText: searchText) { [weak self] (podcast) in
        self?.podcasts = podcast
        self?.tableView.reloadData()
      }
    })
    
    
    

    
  }
  
}
