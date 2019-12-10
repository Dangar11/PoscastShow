//
//  FavoritePodcastCell.swift
//  PoscastShow
//
//  Created by Igor Tkach on 10.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class FavoritePodcastCell: UICollectionViewCell  {
  
  let podcastImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    return imageView
  }()
  
  let podcastLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.numberOfLines = 2
    return label
  }()
  
  let authorLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    return label
  }()
  
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  fileprivate func setupView() {
    
    podcastImageView.heightAnchor.constraint(equalTo: podcastImageView.widthAnchor).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: [
    podcastImageView,
    podcastLabel,
    authorLabel
    ])
    stackView.axis = .vertical
    stackView.spacing = 2
    addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  
  
}
