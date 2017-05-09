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
import SwiftyJSON


class FirstViewController: UIViewController  {

    let storage = FIRStorage.storage()
    var imageArray = [UIImage]()
    var n = 0
    var player: AVPlayer?
 
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var btnPlayPause: UIBarButtonItem!
    @IBOutlet weak var btnBarAvatar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let u_value = snapshot.value {
                
                let json = JSON (u_value)
                for (key, subjson) in json {
                    //print (subjson)
                    if subjson["login"].stringValue == fireUser?.email {// если пользователь - я сам
                        currentUserNick = ( subjson["name"].stringValue + " " + subjson["surname"].stringValue)
                        currentUserEmail = fireUser!.email!
                        // ====== вычисление баланса пользователя по ключу  ===============
                        currentUserKey = key
                        //print ("*** AND The KEY for me is: \(key)")

                        self.getUserBalanceByKey(key: currentUserKey, complition: { (myBalance) in
                            currentUserBalance = myBalance
                            self.navBar.title = "Мои баллы: \(currentUserBalance)"
                            setMyFCMTokenByKey(key: currentUserKey)
                        })
                        
                    }
                }
            }
        })

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
        // Уведомление о поступлении Бонуса
        NotificationCenter.default.addObserver(self, selector: #selector(gotBounsNotif), name: .notificationFromChatVC, object: nil)
      
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.navBar.title = "Мои баллы: \(currentUserBalance)"
    }
    
//=======================================================================
    func gotBounsNotif(notification: Notification) {
//=======================================================================
        
        guard let userInfo = notification.userInfo, let summIn = userInfo["summIn"] as? Float,let key = userInfo["key"] as? String else {return}
        let alert = UIAlertController(title: "Спасибо за покупку!", message: "Вам начислены бонусные баллы в сумме: \(summIn) баллов", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)

    }
    
//============вычисление баланса пользователя по ключу===================
    func getUserBalanceByKey (key: String, complition: @escaping (Float) -> ()) -> () {
//=======================================================================
        var sumBalance: Float = 0

        FIRDatabase.database().reference().child("operations/\(key)").observe(.value, with: { (snapshot) in
            
                if let u_value = snapshot.value {
                sumBalance = 0
                let json = JSON (u_value)
                for (_, subjson) in json {
                    //print (subjson)
                    sumBalance += subjson["scoresDelta"].floatValue
                }
            }
            complition (sumBalance)
            print ("*** AND The Balance for me is: \(sumBalance)")
        })
    }
    
 
    
    @IBAction func btnPausePressed(_ sender: Any) {
        if (player != nil) {
            player = nil
            let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(FirstViewController.btnPausePressed(_:)))
            navBar.leftBarButtonItem = newBarButton
            
        } else {
            
           
            
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
            //let url = URL(string: "http://icecast.vgtrk.cdnvideo.ru/mayakfm_aac_64kbps")
                    let url = URL(string: "http://hi.entranced.fm")
            
            let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            
            let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(FirstViewController.btnPausePressed(_:)))
            navBar.leftBarButtonItem = newBarButton
        }

    }

    @IBAction func btnAvaPressed(_ sender: Any) {
        let manager: ManagerData = ManagerData()
        
        let token = FIRInstanceID.instanceID().token()
        
        manager.sendFCM(toToken: token!, title: "Ералаш:1", body: "", complition: {  (strId, sucDbl) in
            print ("*** message_id: \(strId) ,  Success: \(sucDbl)")
        })
        
    }
    
    
    }



