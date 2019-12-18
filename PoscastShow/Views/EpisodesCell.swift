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
      guard let date = episode?.pubDate, let title = episode?.title, let description = episode?.description, let image = episode?.imageURL else { return }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.yy"
      let dateCreated = dateFormatter.string(from: date)
      dateLabel.text = dateCreated
      episodeLabel.text = title
      descriptionLabel.text = description
      
      guard let url = URL(string: image) else { return }
      episodeImageView.sd_setImage(with: url)
      
    }
  }
  
  
  let episodeImageView: UIImageView = {
    
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
    label.text = "Downcast from John Sundell Downcast from John Sundell"
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
  
  let downloadProgressLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = "100%"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.shadowOffset = CGSize(width: 0, height: 1)
    label.shadowColor = .black
    label.isHidden = true
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
    
    addSubview(episodeImageView)
    episodeImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    episodeImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    episodeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    episodeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    episodeImageView.addSubview(downloadProgressLabel)
    
    downloadProgressLabel.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor).isActive = true
    downloadProgressLabel.centerXAnchor.constraint(equalTo: episodeImageView.centerXAnchor).isActive = true
    
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
    stackViewLabel.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor).isActive = true
    stackViewLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 16).isActive = true
    
  }
  
  
}
