//
//  ViewController.swift
//  TimeMachine
//
//  Created by Joe Longstreet on 6/3/16.
//  Copyright © 2016 Joe Longstreet. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class ViewController: UIViewController, DFBlunoDelegate {
    
    var blunoManager = DFBlunoManager.sharedInstance() as! DFBlunoManager
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        // setup the bluetooth scanner
        self.blunoManager.delegate = self
        self.blunoManager.scan()
        
        // config
        let width = 150.0
        let height = 84.0
        
        // setup the video player and it's resource path
        let path = NSBundle.mainBundle().pathForResource("sample", ofType: "mp4")
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        
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
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        playerLayer.position = CGPoint(x: 0, y: 0.0)
        playerLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        // add the layers to the view
        replicatorLayer.addSublayer(playerLayer)
        self.view.layer.addSublayer(replicatorLayer)
        
        // autoplay
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {   
        return true
    }
    
    
    // MARK: Bluno Delegate Methods
    func bleDidUpdateState(bleSupported: Bool) {
        self.blunoManager.scan()
    }
    
    func didDiscoverDevice(dev: DFBlunoDevice!) {
        blunoManager.connectToDevice(dev)
    }
    
    func readyToCommunicate(dev: DFBlunoDevice!) {
        
    }
    
    func didDisconnectDevice(dev: DFBlunoDevice!) {
        self.blunoManager.scan()
    }
    
    func didWriteData(dev: DFBlunoDevice!) {
        
    }
    
    func didReceiveData(data: NSData!, device dev: DFBlunoDevice!) {
        let textString = String.init(data: data, encoding: NSUTF8StringEncoding)
        NSLog(textString!)
    }
    

}





