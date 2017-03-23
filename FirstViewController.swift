//
//  FirstViewController.swift
//  Prototype1
//
//  Created by Acaraga on 10.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation


class FirstViewController: UIViewController  {

    let storage = FIRStorage.storage()
    var imageArray = [UIImage]()
    var n = 0
    var player: AVPlayer?
 
    @IBOutlet weak var btnPlayPause: UIBarButtonItem!
    @IBOutlet weak var btnBarAvatar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print (fireUser ?? default value)
        
        currentUserNick = "(**unknown yet***)"
        currentUserEmail = fireUser!.email!
        
        // Create a reference to the file you want to download
        let storageRef = self.storage.reference()
        
        // Create a reference to the file you want to upload
        let imgageRef = storageRef.child("profileImages/\(currentUserEmail)/profileImage.png")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imgageRef.data(withMaxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print (error.localizedDescription)
            } else {
               currentUserImage = UIImage(data: data!)

            }
        }
        // Collection View Slide Show
        print ("***********************")

       // print (scrollView.contentSize)
        
       //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 980)

       //  print (scrollView.contentSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnPlayPressed(_ sender: Any) {
        do {try AVAudioSession.sharedInstance().setCategory( AVAudioSessionCategoryPlayback)
            
            do {try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
//                let commandCenter =  MPRemoteCommandCenter.shared()
//                commandCenter.nextTrackCommand.isEnabled = true
//                commandCenter.nextTrackCommand.addTarget(self, action:#selector(nextTrackCommandSelector()))
            } catch let error as NSError {
                print(error)}
            } catch let error as NSError {
                print(error)}
        let url = URL(string: "http://icecast.vgtrk.cdnvideo.ru/mayakfm_aac_64kbps")
//        let url = URL(string: "http://hi.entranced.fm")

        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
    @IBAction func btnPausePressed(_ sender: Any) {
        player?.pause()
        
      //  print(player?.status)
    }
  
}

