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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
  }
  
  
  fileprivate func setupCollectionView() {
    collectionView.backgroundColor = .red
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  
  
  //MARK: CollectionView Source
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    cell.backgroundColor = .blue
    return cell
  }
  
}



//MARK: - CollectionView Sizes
extension FavoritesController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = (view.frame.width - 3 * 16) / 2
    
    
    return CGSize(width: width, height: width)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
}
