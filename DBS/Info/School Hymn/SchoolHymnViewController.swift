//
//  ViewControllerSchoolHymn.swift
//  DBS
//
//  Created by SDG on 27/9/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import AVFoundation

class SchoolHymnViewController : UIViewController {
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var audioLyrics: UITextView!
    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var Restart: UIButton!
    var pause = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        audioLyrics.setContentOffset(CGPoint.zero, animated: true)
        
        
        if let filePath = Bundle.main.path(forResource: "school", ofType: "wav") {
            let fileURL = URL(fileURLWithPath: filePath)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer.prepareToPlay()
            } catch {
                print(error)
            }
        }
        playPause.setTitle("Pause", for: .normal)
        
        
        audioLyrics.frame = CGRect(x: 0, y: self.view.frame.height * 0.15, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        
        playPause.frame = CGRect(x: self.view.frame.width / 2 - self.view.frame.width * 0.05 , y: self.view.frame.height * 0.8, width: self.view.frame.width * 0.1, height: self.view.frame.width * 0.1)
        
        Restart.frame = CGRect(x: self.view.frame.width * 0.25 , y: self.view.frame.height * 0.8, width: self.view.frame.width * 0.1, height: self.view.frame.width * 0.1)
       
        Restart.setImage(UIImage(named: "previous"), for: .normal)
        
        audioLyrics.isEditable = false
        
        self.title = "School Hymn"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        audioPlayer.play()
        audioPlayer.numberOfLoops = -1
    }
    
    @IBAction func playPause(_ sender: Any) {
        if audioPlayer.isPlaying {
            pause = true
            playPause.setImage(UIImage(named: "play"), for: .normal)
            audioPlayer.pause()
        } else {
            playPause.setImage(UIImage(named: "pause"), for: .normal)
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
    }
    
    @IBAction func musicrestart(_ sender: Any) {
        audioPlayer.currentTime = 0
        if audioPlayer.isPlaying {
            audioPlayer.play()
        }
    }
}
