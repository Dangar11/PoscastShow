//
//  PodcastPlayerView.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import AVKit

class PoscastPlayerView: UIView {
  
  
  
  
  // MARK: - Properties
  var episode: Episode? {
    didSet {
      guard let title = episode?.title, let image = episode?.imageURL, let author = episode?.author else { return }
      podcastLabel.text = title
      podcastAuthor.text = author
      
      playEpisode()
      
      
      guard let url = URL(string: image) else { return }
      podcastImageView.sd_setImage(with: url)
    }
  }
  
  let scale: CGFloat = 0.7
  
  let player: AVPlayer = {
    let av = AVPlayer()
    av.automaticallyWaitsToMinimizeStalling = false
    return av
  }()
  
  
  let buttonDismiss: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Dismiss", for: .normal)
    button.tintColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  
  let podcastImageView: UIImageView = {
    let scale: CGFloat = 0.7
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let currentTimeSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.value = 0
    return slider
  }()
  
  
  let startDurationLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "00:02"
    label.font = UIFont.systemFont(ofSize: 12, weight: .light)
    label.textAlignment = .left
    return label
  }()
  
  
  let endDurationLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "00:09:33"
    label.font = UIFont.systemFont(ofSize: 12, weight: .light)
    label.textAlignment = .right
    return label
  }()
  
  
  let podcastLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "My Expirience in Computer Science vs Real World"
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  
  let podcastAuthor: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Brian Voong"
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let playPauseButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
    return button
  }()
  
  
  let rewindButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "rewind15").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let forwardButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "fastforward15").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  
  let volumeSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()
  
  let lessVolumeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "muted_volume").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let moreVolumeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "max_volume").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  
  
  
  //MARK: - ViewLifecycle
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    setupView()
    
    
    observePlayerCurrentTime()
    
    
    //call when caching ended and podcast is started to play
    let time = CMTime(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
      self.enlargePodcastImageView()
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  fileprivate func observePlayerCurrentTime() {
    //reported changeTime notify every 0.5 seconds
    let interval = CMTime(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
      //Extend CMTime
      self.startDurationLabel.text = time.toDisplayString()
      let durationTime = self.player.currentItem?.duration
      self.endDurationLabel.text = durationTime?.toDisplayString()
      
      
      self.updateCurrentTimeSlider()
      
    }
  }
  
  
  fileprivate func updateCurrentTimeSlider()  {
    //Update currentTimeSlider = currentTime / duration
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationInSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationInSeconds
    
    self.currentTimeSlider.value = Float(percentage)
  }
  
  
  // MARK: - Utility Function
  @objc fileprivate func handleDismiss() {
    self.removeFromSuperview()
  }
  
  @objc fileprivate func handlePlayPause() {
    
    if player.timeControlStatus == .paused {
      playPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      player.play()
      enlargePodcastImageView()
    } else {
      playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      player.pause()
      shrinkEpisodeImageView()
    }
  }
  
  
  
  
  
  fileprivate func enlargePodcastImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         self.podcastImageView.transform = .identity
       }, completion: nil)
  }
  
  
  fileprivate func shrinkEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.podcastImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
    }, completion: nil)
  }
  
  fileprivate func playEpisode()  {
    
    print("Trying to play episode at url: ", episode?.streamURL )
    
    guard let streamURL = episode?.streamURL else { return }
    guard let url = URL(string: streamURL) else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  fileprivate func setupView() {
    
    
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
    
    
    
  }
  
  
}
