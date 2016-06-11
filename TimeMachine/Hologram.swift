//
//  Hologram.swift
//  TimeMachine
//
//  Created by Joe Longstreet on 6/10/16.
//  Copyright © 2016 Joe Longstreet. All rights reserved.
//

import Foundation
import AVFoundation

class Hologram {
    
    let videoPlayer = AVPlayer()
    
    func getLayer() -> CAReplicatorLayer{
        // config
        let width = 150.0
        let height = 84.0

        // create the replicator layer
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.anchorPoint = CGPoint(x: 0, y: 0)
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        replicatorLayer.position = CGPoint(x: height, y: 80)
        replicatorLayer.instanceCount = 4

        // create a transformation object
        var transform = CATransform3DIdentity
        let angle:CGFloat = CGFloat(90.0 * M_PI / 180.0)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        transform = CATransform3DTranslate(transform, CGFloat(height), CGFloat(-1*(width+height)), 0)

        // apply the transformation to the replicator instances
        replicatorLayer.instanceTransform = transform

        // create a video player layer
        var playerLayer = AVPlayerLayer()
        playerLayer = AVPlayerLayer(player: self.videoPlayer)
        playerLayer.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        playerLayer.position = CGPoint(x: 0, y: 0.0)
        playerLayer.anchorPoint = CGPoint(x: 0, y: 0)

        // add the player to the replicator
        replicatorLayer.addSublayer(playerLayer)
        
        return replicatorLayer
    }
    
    func loadVideo(path: String){
        let path = NSBundle.mainBundle().pathForResource(path, ofType: "mp4")
        let url = NSURL.init(fileURLWithPath: path!)
        let playerItem = AVPlayerItem(URL: url)
        self.videoPlayer.replaceCurrentItemWithPlayerItem(playerItem)
    }
}