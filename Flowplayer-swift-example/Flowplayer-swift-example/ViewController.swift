//
//  ViewController.swift
//  Flowplayer-swift-example
//
//  Created by Mathias Palm on 2019-01-08.
//  Copyright © 2019 com.appshack. All rights reserved.
//

import UIKit
import Flowplayer

class ViewController: UIViewController {
    @IBOutlet weak var playerView: FLPlayerView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withVideoId: "f0d918c6-3122-4090-b39b-ce376c6e4790", andPlayerId: "999391f8-9119-4ac7-b550-f0f594ec8950")
        playerView.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Just a simple example, u probbably dont want to do this
        if sender.titleLabel?.text == "Play" {
            playerView.play()
            sender.setTitle("Pause", for: .normal)
        } else if sender.titleLabel?.text == "Pause" {
            playerView.pause()
            sender.setTitle("Play", for: .normal)
        }
    }
}

extension ViewController: FLPlayerViewDelegate {
    // CurrentTime is in seconds
    func timeUpdate(_ currentTime: Float) {
        progressLabel.text = "Time elapsed: \(currentTime)"
    }
}

