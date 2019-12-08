//
//  PodcastPlayerView.swift
//  PoscastShow
//
//  Created by Igor Tkach on 28.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PodcastPlayerView: UIView {
  
  
  
  // MARK: - Properties
  var episode: Episode? {
    didSet {
      guard let title = episode?.title, let image = episode?.imageURL, let author = episode?.author else { return }
      podcastLabel.text = title
      podcastAuthor.text = author
      miniPlayerLabel.text = title
    
      
      setupNowPlayingInfo()
      
      playEpisode()
      
      
      guard let url = URL(string: image) else { return }
      podcastImageView.sd_setImage(with: url)
      
      
      //mini player image loading and notification center
      miniPlayerImageView.sd_setImage(with: url) { (image, _, _, _) in
        
        guard let image = image else { return }
        // logscreen artwork setup code
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        //modifications
        let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
          return image
        }
        nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
      }
      
    }
  }
  
  var playlistEpisodes = [Episode]() 
  
  let player: AVPlayer = {
      let av = AVPlayer()
      av.automaticallyWaitsToMinimizeStalling = false
      return av
    }()
  
  
  let scale: CGFloat = 0.7
  
  //MARK: - MAIN PLAYER
  let buttonDismiss: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
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
    slider.addTarget(self, action: #selector(handleCurrentTimeSliderChange), for: .valueChanged)
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
  
  @objc let playPauseButton: UIButton = {
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
    button.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
    return button
  }()
  
  let forwardButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "fastforward15").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
    return button
  }()
  
  
  let volumeSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.addTarget(self, action: #selector(handleVolumeChange), for: .valueChanged)
    return slider
  }()
  
  let lessVolumeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "muted_volume").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleVolumeDown), for: .touchUpInside)
    return button
  }()
  
  let moreVolumeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "max_volume").withRenderingMode(.alwaysOriginal), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleVolumeUp), for: .touchUpInside)
    return button
  }()
  
  
  //MARK: - Mini Player Properties
  
  let miniPlayerView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  
    let miniPlayerImageView: UIImageView = {
      let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.layer.cornerRadius = 5
      imageView.clipsToBounds = true
      return imageView
    }()
    
  let miniPlayerLabel: UILabel = {
      let label = UILabel()
      label.text = "Hello it's let's build that app Hello it's let's build that app"
      label.textAlignment = .left
      label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    let miniPlayerPlayPauseButton: UIButton = {
      let button = UIButton(type: .system)
      button.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
      return button
    }()
    
    
    let miniPlayerForwardButton: UIButton = {
      let button = UIButton(type: .system)
      button.setImage(#imageLiteral(resourceName: "fastforward15").withRenderingMode(.alwaysOriginal), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
      return button
    }()
  
  
  
  
  //MARK: - ViewLifecycle
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    setupRemoteControl()
    setupAudioSession()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    setupView()
    //set from 0.0 - 1.0
    defaultVolumeValue(value: 0.3)
    observePlayerCurrentTime()
    observeBoundaryTime()
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  
  // MARK: - Target Action Function
  
  //MARK: Pan Gesture
  @objc func handleTapMaximize() {
    
    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    mainTabBarController?.maximizePlayerDetails(episode: nil)
    print("Tapping to maximizing")
  }
  
  
  @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
    
    if gesture.state == .changed {
      let translation = gesture.translation(in: superview)
      transform = CGAffineTransform(translationX: 0, y: translation.y)
    } else if gesture.state == .ended {
      let translation = gesture.translation(in: superview)
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.transform = .identity
        if translation.y > 50 {
          let mainTabBarConroller = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
          mainTabBarConroller?.minimizePlayerDetails()
        }
      })
    }
    
  }

  
  //MARK: - Other Handle Action Methods
  //Dismiss
  @objc fileprivate func handleDismiss() {
//    self.removeFromSuperview()
    let mainTapBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    mainTapBarController?.minimizePlayerDetails()
  }
  
  //Pause-Play
  @objc func handlePlayPause() {
    
    if player.timeControlStatus == .paused {
      playPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      player.play()
      enlargePodcastImageView()
    } else {
      playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      player.pause()
      shrinkEpisodeImageView()
    }
  }
  
  //Time Slider
  @objc fileprivate func handleCurrentTimeSliderChange() {
    
    let percantage = currentTimeSlider.value
    //set the playback to current time
    
    guard let duration = player.currentItem?.duration else { return }
      
    let durationInSeconds = CMTimeGetSeconds(duration)
    
    let seekTimeInSeconds = Float64(percantage) * durationInSeconds
    //Time object to represent number of seconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
    
    player.seek(to: seekTime)
  }
  
  
  @objc fileprivate func handleForward() {
    seekToCurrentTime(delta: 15)
  }
  
  @objc fileprivate func handleRewind() {
    seekToCurrentTime(delta: -15)
  }
  
  fileprivate func seekToCurrentTime(delta: Int64) {
    let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
    let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
    player.seek(to: seekTime)
  }
  
  
  //MARK: Volume
  @objc fileprivate func handleVolumeChange() {
    player.volume = volumeSlider.value
  }
  
  
  @objc fileprivate func handleVolumeUp() {
    let volumeUp = volumeSlider.value + 0.1
    volumeSlider.value = volumeUp
    let volume = min(1, volumeUp)
    print("VolumeUp: ", volume)
    player.volume = min(1, volumeUp)
  }
  
  @objc fileprivate func handleVolumeDown() {
    let volumeDown = volumeSlider.value - 0.1
    volumeSlider.value = volumeDown
    let volume = max(0, volumeDown)
    print("VolumeDown: ", volume)
    player.volume = max(0, volumeDown)
  }
  
  
  
}
