//
//  File.swift
//  PoscastShow
//
//  Created by Igor Tkach on 01.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


extension PodcastPlayerView {
  
  
  
  
  func setupView() {
  
    
    addSubview(podcastImageView)
    addSubview(buttonDismiss)
    addSubview(currentTimeSlider)
    
    
    
    
    buttonDismiss.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
    buttonDismiss.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    buttonDismiss.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
    
    podcastImageView.topAnchor.constraint(equalTo: buttonDismiss.bottomAnchor, constant: 20).isActive = true
    //for different screen multiplier
    podcastImageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.45).isActive = true
    podcastImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
    podcastImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
    podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    currentTimeSlider.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: 10).isActive = true
    currentTimeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
    currentTimeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
    
    
    let durationStackView = UIStackView(arrangedSubviews: [
    startDurationLabel,
    endDurationLabel
    ])
    
    durationStackView.distribution = .fillEqually
    durationStackView.translatesAutoresizingMaskIntoConstraints = false
    
    
    addSubview(durationStackView)
    
    
    durationStackView.topAnchor.constraint(equalTo: currentTimeSlider.bottomAnchor, constant: 5).isActive = true
    durationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
    durationStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
    
    
    
    let authorStackView = UIStackView(arrangedSubviews: [
    podcastLabel,
    podcastAuthor
    ])
    
    authorStackView.alignment = .center
    authorStackView.axis = .vertical
    authorStackView.distribution = .fillEqually
    authorStackView.translatesAutoresizingMaskIntoConstraints = false
    
    
    addSubview(authorStackView)
    

    authorStackView.topAnchor.constraint(lessThanOrEqualTo: durationStackView.bottomAnchor, constant: 10).isActive = true
    authorStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
    authorStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
    
    
    let controlButtonStackView = UIStackView(arrangedSubviews: [
    rewindButton,
    playPauseButton,
    forwardButton
    ])
    
    controlButtonStackView.translatesAutoresizingMaskIntoConstraints = false
    controlButtonStackView.distribution = .fillEqually
    controlButtonStackView.alignment = .center
    
    addSubview(controlButtonStackView)
    
    controlButtonStackView.topAnchor.constraint(equalTo: authorStackView.bottomAnchor, constant: 10).isActive = true
    controlButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42).isActive = true
    controlButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42).isActive = true
    
    let volumeStackView = UIStackView(arrangedSubviews: [
    lessVolumeButton,
    volumeSlider,
    moreVolumeButton
    ])
    
    volumeStackView.distribution = .fill
    volumeStackView.alignment = .center
    volumeStackView.spacing = 5
    volumeStackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(volumeStackView)
    
    volumeStackView.topAnchor.constraint(lessThanOrEqualTo: controlButtonStackView.bottomAnchor, constant: 20).isActive = true
    volumeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
    volumeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
    
    miniPlayerViewSetup()
    
  }
  
  
  
  fileprivate func miniPlayerViewSetup() {
      addSubview(miniPlayerView)
     
     miniPlayerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
     miniPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
     miniPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
     miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
     
     
     miniPlayerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
     miniPlayerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true


     miniPlayerLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
    
    miniPlayerPlayPauseButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    miniPlayerPlayPauseButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
    
    miniPlayerForwardButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    miniPlayerForwardButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
    

     let horizontalStackView = UIStackView(arrangedSubviews: [
     miniPlayerImageView,
     miniPlayerLabel,
     miniPlayerPlayPauseButton,
     miniPlayerForwardButton
     ])
     horizontalStackView.distribution = .fill
     horizontalStackView.spacing = 5
    
    miniPlayerView.addSubview(horizontalStackView)


     horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontalStackView.topAnchor.constraint(equalTo: miniPlayerView.topAnchor, constant: 8).isActive = true
    horizontalStackView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor, constant: 8).isActive = true
    horizontalStackView.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor, constant: -8).isActive = true
    horizontalStackView.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor, constant: -8).isActive = true
   }
  
}
