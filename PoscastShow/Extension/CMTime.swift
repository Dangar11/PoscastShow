//
//  CMTime.swift
//  PoscastShow
//
//  Created by Igor Tkach on 29.11.2019.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import AVKit


extension CMTime {
  
  
  func toDisplayString() -> String {
    //bug fixes for crash infinite number
    if CMTimeGetSeconds(self).isNaN {
      return "--:--"
    }
    let totalSeconds = Int(CMTimeGetSeconds(self))
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60
    let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
    
    return timeFormatString
  }
  
}
