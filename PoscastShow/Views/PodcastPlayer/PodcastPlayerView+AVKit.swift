//
//  PodcastPlayerView+AVKit.swift
//  PoscastShow
//
//  Created by Igor Tkach on 01.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import AVKit
import UIKit
import MediaPlayer


extension PodcastPlayerView {
  
 
  
   func observePlayerCurrentTime() {
    //reported changeTime notify every 0.5 seconds
    let interval = CMTime(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
      //Extend CMTime
      self?.startDurationLabel.text = time.toDisplayString()
      let durationTime = self?.player.currentItem?.duration
      self?.endDurationLabel.text = durationTime?.toDisplayString()
      
      
      self?.updateCurrentTimeSlider()
      
    }
  }
  
  
   func normalPlayback() {
    //call when caching ended and podcast is started to play
    let time = CMTime(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      self?.enlargePodcastImageView()
    }
  }
  
  
   func updateCurrentTimeSlider()  {
    //Update currentTimeSlider = currentTime / duration
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationInSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationInSeconds
    
    self.currentTimeSlider.value = Float(percentage)
  }
  
  
  //MARK: - Utility Function
   func enlargePodcastImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         self.podcastImageView.transform = .identity
       }, completion: nil)
  }
  
  
   func shrinkEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.podcastImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
    }, completion: nil)
  }
  
   func playEpisode()  {
  
    guard let streamURL = episode?.streamURL else { return }
    guard let url = URL(string: streamURL) else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  
  //Set defaultVolumeValue
   func defaultVolumeValue(value: Float) {
    volumeSlider.value = value
    player.volume = value
  }
  
  //Background audio session
  func setupAudioSession() {
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback)
       try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    } catch let sessionError {
      print("Failed to activate session:", sessionError)
    }
    
  }
  
  //MARK: - Command Center
  
  func setupRemoteControl() {
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    let commandCenter = MPRemoteCommandCenter.shared()

    //PLAY BUTTON
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.player.play()
      self.playPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      self.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      return .success
    }
    //PAUSE BUTTON
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.player.pause()
      self.playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      self.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      return .success
    }
    
    //Handle Earpods and Airpods headphones play/pause functionality.
    commandCenter.togglePlayPauseCommand.isEnabled = true
    commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      
      self.handlePlayPause()
      
      return .success
    }
    
  }
  
}
