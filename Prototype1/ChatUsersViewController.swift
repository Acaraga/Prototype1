//
//  ChatUsersViewController.swift
//  Prototype1
//
//  Created by Acaraga on 20.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SwiftyJSON





class ChatUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var ref: FIRDatabaseReference!
    var postRef: FIRDatabaseReference!
    var refHandle =  UInt()
    // Create a reference to the file you want to download
    let storage = FIRStorage.storage()

    // создание параллельной  очереди
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    let group = DispatchGroup()

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailsArray :[String] = []
    var nicknamesArray: [String] = []
    var fireKeysArray: [String] = []

    var profileImageArray: [UIImage?]?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//}
    //override func viewDidAppear(_ animated: Bool) {

        
        FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
            if let u_value = snapshot.value {

                self.userEmailsArray.removeAll(keepingCapacity: false)
                self.nicknamesArray.removeAll(keepingCapacity: false)
                self.fireKeysArray.removeAll(keepingCapacity: false)
                self.profileImageArray = nil

                let json = JSON (u_value)
                for (key, subjson) in json {
                //    print (subjson)
                if subjson["login"].stringValue == fireUser?.email {// если пользователь - я сам
                    currentUserNick = ( subjson["name"].stringValue + " " + subjson["surname"].stringValue)
                    currentUserEmail = fireUser!.email!
                    currentUserBalance = subjson["balance"].floatValue
                    
                } else { // если остальные - добавляем в массив чатов
                    self.nicknamesArray.append( subjson["name"].stringValue + " " + subjson["surname"].stringValue)
                    self.userEmailsArray.append(subjson["login"].stringValue)
                    self.fireKeysArray.append(key)
                    
                    }
                    
                }
                self.profileImageArray = [UIImage?](repeatElement(nil, count: self.userEmailsArray.count))
                self.fetchProfileImageData()
                self.tableView.reloadData()
            }
        })
        
    }
//====================================================================================
    func fetchProfileImageData() { //  ЗАГРУЗКА АВАТАРОК
//====================================================================================
        // Create a reference to the file you want to upload
        let storageRef = self.storage.reference()
        
        for c in 0 ..< userEmailsArray.count {
        
        let imgageRef = storageRef.child("profileImages/\(userEmailsArray[c])/profileImage.png")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imgageRef.data(withMaxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print (error.localizedDescription)
            } else {
                // self.btnBarAvatar.image = UIImage(data: data!)
                self.profileImageArray?[c] = (UIImage(data: data!))
                self.tableView.reloadData()
                print ("*** reload")
                

            }
        }
        
        
    }
        
      }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
        return nicknamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! UserTableViewCell
        cell.lblLogin.text = nicknamesArray[indexPath.row]
        cell.lblEmail.text = userEmailsArray[indexPath.row]
        cell.imgProfile.image = self.profileImageArray?[indexPath.row] == nil ? (UIImage.init(named: "2_002")!) : self.profileImageArray?[indexPath.row]
         
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        
        recipientEmail = cell.lblEmail.text!
        recipientNick = cell.lblLogin.text!
        recipientImage = cell.imgProfile.image
        let firekey = self.fireKeysArray[indexPath.row]
        getUserFCMTokenByKey(key: firekey) { (token) in
            recipientFCMToken = token
        }
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        
    }
    
    @IBAction func btnRefreshPressed(_ sender: Any) {
        self.tableView.reloadData()
    }

}
