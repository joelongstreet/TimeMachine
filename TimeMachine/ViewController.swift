//
//  ViewController.swift
//  TimeMachine
//
//  Created by Joe Longstreet on 6/3/16.
//  Copyright © 2016 Joe Longstreet. All rights reserved.
//

import UIKit
import AVKit


class ViewController: UIViewController, DFBlunoDelegate {
    
    var blunoManager = DFBlunoManager.sharedInstance() as! DFBlunoManager
    var hologram = Hologram()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        // setup the bluetooth scanner
        self.blunoManager.delegate = self
        
        // make the hologram layer and add as a sublayer
        let hologramLayer = hologram.getLayer()
        self.view.layer.addSublayer(hologramLayer)
        
        // load a hologram video
        hologram.loadVideo("sample")
        hologram.videoPlayer.play()
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
