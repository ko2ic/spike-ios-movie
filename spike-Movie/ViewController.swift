//
//  ViewController.swift
//  spike-Movie
//
//  Created by koji.ishii on 2020/10/01.
//  Copyright © 2020 koji.ishii. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ViewController: UIViewController {

    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
                
        } catch {
            print("failed.")
        }

        do {
            try audioSession.setActive(true)
        } catch {
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidEnterBackground(
            notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func playMovie(fileName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Url is nil")
            return
        }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
            
        playerController.player = player
        
        self.present(playerController, animated: true) {
            self.player.play()
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        playMovie(fileName: "movie", fileExtension: "mp4")
    }
    
    func changeVideoTrackState(isEnabled: Bool){
        if let tracks = player.currentItem?.tracks {
            print("isEnabled")
            print(isEnabled)
            
            print("tracksCount")
            print(tracks.count)
          for playerItemTrack in tracks {
            print("--------------------playerItemTrack")
            print(playerItemTrack.assetTrack)
            // Find the video tracks.
            if let assetTrack = playerItemTrack.assetTrack, assetTrack.hasMediaCharacteristic(.visual) {
              // Enable/Disable the track.
              playerItemTrack.isEnabled = isEnabled
                print("-------------\(isEnabled)")
            }
          }
      }
    }
    
    @objc func viewWillEnterForeground(notification: Notification) {
        changeVideoTrackState(isEnabled: true)
    }

    @objc func viewDidEnterBackground(notification: Notification) {
        changeVideoTrackState(isEnabled: false)
    }
}
