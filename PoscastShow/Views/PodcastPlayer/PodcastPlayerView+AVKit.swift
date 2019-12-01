//
//  PodcastPlayerView+AVKit.swift
//  PoscastShow
//
//  Created by Igor Tkach on 01.12.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import AVKit
import UIKit


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
  
  
}
