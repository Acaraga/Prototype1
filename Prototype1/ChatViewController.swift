//
//  ChatViewController.swift
//  Prototype1
//
//  Created by Acaraga on 21.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SwiftyJSON
import AVFoundation

var recipientEmail = ""
var recipientNick = ""
var recipientImage: UIImage?
var recipientFCMToken = ""
var isBlocked = false



class ChatViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var msgTextView: UITextView!

    @IBOutlet weak var chatScrollView: UIScrollView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var promptLabel: UILabel!
    
    //var messageArray = [String]()
    var messageArray: [(date: NSDate, message: String, sender: String)] = []
    var senderArray = [String]()
 //   var currentUserImage: UIImage?
 //   var recipientImage: UIImage?
    
    var messageViewY : CGFloat = 0
    var chatScrollH : CGFloat = 0
    
    let storage = FIRStorage.storage()
    var   ref = FIRDatabase.database().reference()
    var refHandle =  UInt()
    
    // Create a reference to the file you want to download
    
    // создание параллельной  очереди
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    let group = DispatchGroup()
    //==========================================================================================
    override func viewDidLoad() {
        //==========================================================================================
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //msgTextView.
        
        self.title = recipientNick
        
        // Define identifier
        let notificationName = Notification.Name("UIKeyboardDidShowNotification")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: Notification.Name("UIKeyboardDidHideNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChat), name: Notification.Name("updateChatNow"), object: nil)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.didTapScrollView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        chatScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
//==========================================================================================
    func didTapScrollView() {
//==========================================================================================
        self.view.endEditing(true)
    }
    
//==========================================================================================
    func keyboardDidShow(notification: NSNotification) {
//==========================================================================================
        
        let dict: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize: NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let frameKeyBoardSize: CGRect = keyboardSize.cgRectValue
        let screenH = UIScreen.main.bounds.height
        
        let newY = screenH - frameKeyBoardSize.height - messageView.frame.size.height
  
        UIView.animate(withDuration: 0.3, animations: {
            self.messageView.frame.origin.y = newY

            let chatScrollViewOffset = self.messageViewY - newY
            
            self.chatScrollView.frame.size.height = self.chatScrollH - chatScrollViewOffset
            
            let scrollViewOffset : CGPoint = CGPoint(x: 0, y: self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height)
            self.chatScrollView.setContentOffset(scrollViewOffset, animated: true)
            
        }, completion: nil )
    }
//==========================================================================================
    func keyboardDidHide(notification: NSNotification) {
//==========================================================================================
//        let dict: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize: NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//        let frameKeyBoardSize: CGRect = keyboardSize.cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: {
          //  let chatScrollViewOffset = self.messageViewY - self.messageView.frame.origin.y
//             print ("*** chatScrollViewOffset, messageViewY: \(chatScrollViewOffset, self.messageViewY) ")
            self.chatScrollView.frame.size.height = self.chatScrollH
            self.messageView.frame.origin.y = self.messageViewY
            
        }, completion: nil)
        
    }
//==========================================================================================
    func textViewDidChange(_ textView: UITextView) {
//==========================================================================================
        self.promptLabel.isHidden = msgTextView.hasText ? true : false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !self.msgTextView.hasText {
            self.promptLabel.isHidden = true
        }
    }
    
    //==========================================================================================
    override func viewDidAppear(_ animated: Bool) {
        //==========================================================================================
        messageViewY = messageView.frame.origin.y
        chatScrollH = self.chatScrollView.frame.size.height

        FIRDatabase.database().reference().child("messages").observe(.value, with: { (snapshot) in
            if let m_value = snapshot.value {
                self.messageArray.removeAll(keepingCapacity: false)
                self.senderArray.removeAll(keepingCapacity: false)
                
                let json = JSON (m_value)
                for (key, subjson) in json {
                    //print (subjson)
                    if subjson["sender"].stringValue == fireUser?.email &&
                        subjson["recipient"].stringValue == recipientEmail {// если я отправитель
                        self.messageArray.append(( dateFromString(date: subjson["date"].stringValue)!,
                                                                        subjson["message"].stringValue,
                                                                        subjson["sender"].stringValue))
                        //print (subjson)
                    } else if subjson["recipient"].stringValue == fireUser?.email &&
                        subjson["sender"].stringValue == recipientEmail {// если я получатель
                        // проверим поступление спец сообщения о начислениях бонусов
                        //***************************************************************
                        let msgText = subjson["message"].stringValue
                        if msgText.contains("Givebonus+") {
                            let arr = msgText.components(separatedBy: " ")
                            if let summIn = Float(arr[1]) {
                                print (" *** Bonus incoming!: \(summIn)")
                                let dict = ["summIn": summIn,
                                            "key": key] as [String : Any]
                                NotificationCenter.default.post(name: .notificationFromChatVC , object: nil, userInfo: dict)
                            } else {
                            print (" *** Bonus Error in: \(msgText)")
                        
                            }
                           
                        } else {
                        //***************************************************************
                        self.messageArray.append(( dateFromString(date: subjson["date"].stringValue)!,
                                                                        subjson["message"].stringValue,
                                                                        subjson["sender"].stringValue))
                        }
                        //print (subjson)
                    }
                }
            self.updateChat()
            }
        })
   
    }
//        let isBlockedPredicate = NSPredicate(format: "user == %@ AND blockedUser == %@", recipientNick, currentUserName)
//        let isBlockedQuery = PFQuery (className: "Block", predicate: isBlockedPredicate)
//        isBlockedQuery.findObjectsInBackground { ( objects: [PFObject]?, error: Error?) in
//            if objects!.count > 0 {
//                isBlocked = true
//            } else {
//                isBlocked = false
//            }
//        }
//        
//        
//        let blockPredicate = NSPredicate (format: "user == %@ AND blockedUser == %@", currentUserName, recipientNick)
//        let blockQuery = PFQuery(className: "Block", predicate: blockPredicate)
//        blockQuery.findObjectsInBackground { (objects : [PFObject]?, error: Error?) in
//            print ("-== Block status: \(objects?.count)")
//            self.blockUnblockBtn.title = !((objects?.isEmpty)!) ?  "Разбл." : "Блок"
//            
//        }
//        //            if objects!.isEmpty { self.blockUnblockBtn.title = "Разбл." } else {
//        //                self.blockUnblockBtn.title = "бл."
//        //            }
//        
//        
//        
//        var userImageArray = [PFFile]()
//        
//        let queryForCurrentUser = PFQuery(className: "_User")
//        queryForCurrentUser.whereKey("username", equalTo: currentUserName)
//        
//        queryForCurrentUser.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//            
//            for object in objects! {
//                userImageArray.append(object["image"] as! PFFile)
//                userImageArray.first?.getDataInBackground(block: { (imgageData: Data?, error: Error?) in
//                    
//                    if error == nil {
//                        self.currentUserImage = UIImage(data: imgageData!)
//                        userImageArray.removeAll(keepingCapacity: false)
//                        
//                    }
//                    
//                })
//                
//            }
//        }
//        let queryForRecipient = PFQuery(className: "_User")
//        queryForRecipient.whereKey("username", equalTo: recipientNick)
//        
//        queryForRecipient.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//            
//            for object in objects! {
//                userImageArray.append(object["image"] as! PFFile)
//                userImageArray.first?.getDataInBackground(block: { (imgageData: Data?, error: Error?) in
//                    
//                    if error == nil {
//                        self.recipientImage = UIImage(data: imgageData!)
//                        userImageArray.removeAll(keepingCapacity: false)
//                        
//                    }
//                    
//                })
//                
//            }
//            
//        }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//==========================================================================================
    func updateChat() {
//==========================================================================================
        let messageMarginX : CGFloat = 45
        var messageMarginY : CGFloat = 27
        
        let bubbleMarginX : CGFloat = 40
        var bubbleMarginY : CGFloat = 21
        
        let imageMarginX : CGFloat = 15
        var imageMarginY : CGFloat = 5
        
        // сортировка по времени сообщения
        messageArray.sort(by: { (first, second) -> Bool in
            return first.date < second.date
        })

                for i in 0..<self.messageArray.count {
                    if self.messageArray[i].sender == currentUserEmail {
                        
                        let messageLabel = UILabel()
                        messageLabel.text = self.messageArray[i].message
                        messageLabel.frame = CGRect(x: 0, y: 0, width: self.chatScrollView.frame.size.width - 90, height: CGFloat.greatestFiniteMagnitude)
                        messageLabel.numberOfLines = 0
                        messageLabel.lineBreakMode = .byWordWrapping
                        messageLabel.sizeToFit()
                        messageLabel.textAlignment = .left
                        messageLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
                        messageLabel.textColor = UIColor.gray
                        messageLabel.backgroundColor = UIColor.white
                        
                        messageLabel.frame.origin.x = self.chatScrollView.frame.size.width - messageMarginX - messageLabel.frame.size.width
                        messageLabel.frame.origin.y = messageMarginY
                        messageMarginY += messageLabel.frame.size.height + 30
                        self.chatScrollView.addSubview(messageLabel)
                        
                        let bubbleLabel = UILabel()
                        bubbleLabel.frame.size = CGSize(width: messageLabel.frame.size.width + 10, height: messageLabel.frame.size.height + 10)
                        
                        bubbleLabel.frame.origin.x = self.chatScrollView.frame.size.width - bubbleLabel.frame.size.width - bubbleMarginX
                        bubbleLabel.frame.origin.y = bubbleMarginY
                        bubbleMarginY += messageLabel.frame.size.height + 30
                        bubbleLabel.layer.cornerRadius = 10
                        bubbleLabel.clipsToBounds = true
                        bubbleLabel.backgroundColor = UIColor.white
                        
                        self.chatScrollView.addSubview (bubbleLabel)
                        
                        
                        let width = self.view.frame.size.width
                        self.chatScrollView.contentSize = CGSize(width: width, height: messageMarginY)
                        self.chatScrollView.bringSubview(toFront: messageLabel)
                        
                        let senderImage = UIImageView()
                        senderImage.image = currentUserImage
                        senderImage.frame.size = CGSize (width: 35, height: 35)
                        senderImage.frame.origin = CGPoint(x: self.chatScrollView.frame.size.width - senderImage.frame.size.width - imageMarginX, y: imageMarginY)
                        senderImage.layer.cornerRadius = 35 / 2
                        senderImage.clipsToBounds = true
                        self.chatScrollView.addSubview(senderImage)
                        
                        imageMarginY += messageLabel.frame.size.height + 30
                        self.chatScrollView.bringSubview(toFront: senderImage)
                        
                        
                    } else {
                        let messageLabel = UILabel()
                        messageLabel.text = self.messageArray[i].message
                        messageLabel.frame = CGRect(x: 0, y: 0, width: self.chatScrollView.frame.size.width - 90, height: CGFloat.greatestFiniteMagnitude)
                        messageLabel.numberOfLines = 0
                        messageLabel.lineBreakMode = .byWordWrapping
                        messageLabel.sizeToFit()
                        messageLabel.textAlignment = .left
                        messageLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
                        messageLabel.textColor = UIColor.gray
                        messageLabel.backgroundColor = UIColor.white
                        
                        messageLabel.frame.origin.x = messageMarginX
                        messageLabel.frame.origin.y = messageMarginY
                        messageMarginY += messageLabel.frame.size.height + 30
                        self.chatScrollView.addSubview(messageLabel)
                        
                        let bubbleLabel = UILabel()
                        bubbleLabel.frame = CGRect (x: bubbleMarginX, y: bubbleMarginY, width: messageLabel.frame.size.width + 10,
                                                    height: messageLabel.frame.size.height + 20)
                        
                        bubbleMarginY += messageLabel.frame.size.height + 30
                        bubbleLabel.layer.cornerRadius = 10
                        bubbleLabel.clipsToBounds = true
                        bubbleLabel.backgroundColor = UIColor.white
                        
                        self.chatScrollView.addSubview (bubbleLabel)
                        
                        let width = self.view.frame.size.width
                        self.chatScrollView.contentSize = CGSize(width: width, height: messageMarginY)
                        self.chatScrollView.bringSubview(toFront: messageLabel)
                        
                        
                        let senderImage = UIImageView()
                        senderImage.image = recipientImage
                        //
                        senderImage.frame = CGRect(x: imageMarginX, y: imageMarginY, width: 35, height: 35)
                        senderImage.layer.cornerRadius = 35 / 2
                        senderImage.clipsToBounds = true
                        self.chatScrollView.addSubview(senderImage)
                        
                        imageMarginY += messageLabel.frame.size.height + 30
                        self.chatScrollView.bringSubview(toFront: senderImage)
                        
                    }
                    
                    let scrollViewOffset : CGPoint = CGPoint(x: 0, y: self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height)
                    self.chatScrollView.setContentOffset(scrollViewOffset, animated: true)
                }
        
            }

//==========================================================================================
    @IBAction func sendBtnPressed(_ sender: AnyObject) {
//==========================================================================================
        if isBlocked {
            let alert = UIAlertController(title: "Заблокирован", message: "\(recipientNick) заблокировал тебя", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        didTapScrollView()
        
        if msgTextView.text.isEmpty {
            
            print ("@@@no text in msg@@@")
        } else {
            
            self.ref.child("messages").childByAutoId().setValue([ "sender": currentUserEmail,
                                                                  "recipient": recipientEmail,
                                                                  "date": String(describing: Date()),
                                                                  "message": self.msgTextView.text!])
            
// ************************************ [PUSH SECTION] ****************************
                    let manager = ManagerData()
            manager.sendFCM(toToken: recipientFCMToken, title: currentUserNick, body: self.msgTextView.text!, complition: { (msgid, success) in
                    print ("*** message sent *** pushid: \(msgid) success: \(success)")
                    })
// ************************************ [ END PUSH ] ******************************
            
                    self.msgTextView.text = ""
                    self.promptLabel.isHidden = false
            
         }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
