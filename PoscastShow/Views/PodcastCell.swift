//
//  PodcastCell.swift
//  PoscastShow
//
//  Created by Igor Tkach on 25.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import SDWebImage



class PoscastCell: UITableViewCell {
  
  var podcast: Podcast? {
    didSet {
      if let artist = podcast?.artistName, let image = podcast?.artworkUrl600, let episode = podcast?.collectionName, let episodeCount = podcast?.trackCount {
        episodeNameLabel.text = episode
        episodeAuthor.text = artist
        podcastImageView.image = #imageLiteral(resourceName: "appicon")
        episodesCountLabel.text = "\(episodeCount) Episodes"
        
        
        guard let url = URL(string: image) else { return }
        
        podcastImageView.sd_setImage(with: url, completed: nil)
        
      }
    }
  }
  
  
  let podcastImageView: UIImageView = {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  
  
  let episodeNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .black
    label.text = "Brian Voong"
    label.numberOfLines = 2
    return label
  }()
  
  let episodeAuthor: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .black
    label.text = "Let's Build that App"
    return label
  }()
  
  let episodesCountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    label.text = "50 episodes"
    return label
  }()
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupUI() {
    
    addSubview(podcastImageView)
    podcastImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    podcastImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    podcastImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    let stackViewLabel = UIStackView(arrangedSubviews: [
    episodeNameLabel,
    episodeAuthor,
    episodesCountLabel
    ])
    
    stackViewLabel.axis = .vertical
    stackViewLabel.alignment = .fill
    stackViewLabel.distribution = .fill
    stackViewLabel.spacing = 10
    addSubview(stackViewLabel)
    
    
    stackViewLabel.translatesAutoresizingMaskIntoConstraints = false
    
    stackViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    stackViewLabel.centerYAnchor.constraint(equalTo: podcastImageView.centerYAnchor).isActive = true
    stackViewLabel.leadingAnchor.constraint(equalTo: podcastImageView.trailingAnchor, constant: 16).isActive = true
    
  }
  
  
}
