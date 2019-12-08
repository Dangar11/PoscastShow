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

  
  
  
  
   func observeBoundaryTime() {
    //call when caching ended and podcast is started to play
    let time = CMTime(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      self?.enlargePodcastImageView()
      self?.setupLockscreenDuration()
    }
  }
  
  //Fix duration elepsed time
  func setupLockscreenDuration() {
    guard let duration = player.currentItem?.duration else { return }
    let durationSeconds = CMTimeGetSeconds(duration)
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
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
      self.setupElapsedTime(playbackRate: 1)
      return .success
    }
    //PAUSE BUTTON
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.player.pause()
      self.playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      self.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      self.setupElapsedTime(playbackRate: 0)
    
      return .success
    }
    
    //Handle Earpods and Airpods headphones play/pause functionality.
    commandCenter.togglePlayPauseCommand.isEnabled = true
    commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      
      self.handlePlayPause()
      
      return .success
    }
    
    //Next Track
    
    commandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      
      self.handleNextTrack()
      return .success
    }
    
    //Previous Track
    
    commandCenter.previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      
      self.handlePreviousTrack()
      return .success
      
    }
    
  }
  
  
   func setupElapsedTime(playbackRate: Float) {
      let elapsedTime = CMTimeGetSeconds(player.currentTime())
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
  }
  
  //MARK: NextTrack
   fileprivate func handleNextTrack() {

    // if empty return nothing
    if playlistEpisodes.count == 0 {
      return
    }
    // current episode index
    let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
      return self.episode?.title == ep.title && self.episode?.author == ep.author
    }
    
    guard let index = currentEpisodeIndex else { return }
    
    
    let nextEpisode: Episode
    if index == playlistEpisodes.count - 1 {
       nextEpisode = playlistEpisodes[0]
    } else {
       nextEpisode = playlistEpisodes[index + 1]
    }
    
    self.episode = nextEpisode
    
  }
  
  //MARK: PreviousTrack
  fileprivate func handlePreviousTrack() {
    // 1. check if playlistEpisodes.count == 0 then return
    // 2. find out current episode index
    // 3. if episode index is 0, wrap to end of list somehow..
          // otherwise play episode index - 1
    if playlistEpisodes.count == 0 {
      return
    }
    
    let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
      return self.episode?.title == ep.title && self.episode?.author == ep.author
    }
    
    guard let index = currentEpisodeIndex else { return }
    
    let prevEpisode: Episode
    if index == 0 {
      prevEpisode = playlistEpisodes[playlistEpisodes.count - 1] // end of the list
    } else {
      prevEpisode = playlistEpisodes[index - 1]
    }
    self.episode = prevEpisode
    
    
  }
  
  
  
  
  
  func setupNowPlayingInfo() {
    var nowPlayingInfo = [String: Any]()
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = episode?.author
    
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  
  //MARK: Interruption FIX when phone called, when other player starting to play, video, and other...
  
  
  func setupInterruptionObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
  }
  
  @objc fileprivate func handleInterruption(notification: Notification) {
    
    guard let userInfo = notification.userInfo else { return }
    guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
    
    if type == AVAudioSession.InterruptionType.began.rawValue {
      print("Interaption began...")
      playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
      miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
    } else {
      print("Interaption ended...")
      guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
      
      if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
        miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
      }
      
    }
    
  }
  
}
