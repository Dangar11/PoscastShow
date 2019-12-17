//
//  FavoritesController.swift
//  PoscastShow
//
//  Created by Igor Tkach on 08.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class FavoritesController: UICollectionViewController {
  
  
  let cellId = "favoritesIdCell"
  
  var podcasts = UserDefaults.standard.savedPodcast()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    podcasts = UserDefaults.standard.savedPodcast()
    collectionView.reloadData()
    //hide badge when taping into it
    UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
  }
  
  fileprivate func setupCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    collectionView.addGestureRecognizer(gesture)
  }
  
  
  
  //MARK: CollectionView Source
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
    cell.podcast = self.podcasts[indexPath.item]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let episodesController = EpisodesController()
    episodesController.podcast = self.podcasts[indexPath.item]
    
    navigationController?.pushViewController(episodesController, animated: true)
  }
  
  
  
  @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
  
    //get indexPath by location CGpoint
    let location = gesture.location(in: collectionView)
    
    guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
    
    print(selectedIndexPath.item)
    
    let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
      //remove podcast from collecitonView
      let selectedPodcast = self.podcasts[selectedIndexPath.item]
      self.podcasts.remove(at: selectedIndexPath.item)
      UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
      self.collectionView.deleteItems(at: [selectedIndexPath])
      //remove from userDefaults
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alertController, animated: true)
  }
  
}



//MARK: - CollectionView Sizes
extension FavoritesController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = (view.frame.width - 3 * 16) / 2
    
    
    return CGSize(width: width, height: width + 60)
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
}
