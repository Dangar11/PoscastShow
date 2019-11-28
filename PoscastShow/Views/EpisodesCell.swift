//
//  EpisodesCell.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class EpisodesCell: UITableViewCell {
  
  
  var episode: Episode? {
    didSet {
      guard let date = episode?.pubDate, let title = episode?.title, let description = episode?.description else { return }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.yy"
      let dateCreated = dateFormatter.string(from: date)
      dateLabel.text = dateCreated
      episodeLabel.text = title
      descriptionLabel.text = description
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
  
  
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    label.text = "MONDAY"
    return label
  }()
  
  let episodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .black
    label.numberOfLines = 2
    label.text = "Let's Build that AppLet's Build that AppLet's Build that AppLet's Build that AppLet's Build that App"
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .light)
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    label.numberOfLines = 2
    label.text = "50 episodes50 episodes50 episodes50 episodes50 episodes50 episodes50 episodes"
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
    dateLabel,
    episodeLabel,
    descriptionLabel
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
