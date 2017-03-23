//
//  regViewController.swift
//  Prototype1
//
//  Created by Acaraga on 14.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import Firebase

class regViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    let storage = FIRStorage.storage()
    var   ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imgUser: UIImageView!
 
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtSurname: UITextField!
    
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtPass2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
                self.view.endEditing(true)
        for var subview in self.imageView.subviews {
            if subview.tag == 2 { subview.removeFromSuperview()
            }
        }

    }
    @IBAction func btnClosePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func btnUserImgPressed(_ sender: Any) {
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imageVC.allowsEditing = true
        self.present(imageVC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image : UIImage? = info["UIImagePickerControllerEditedImage"] as? UIImage
        imgUser.image = image
        self.dismiss(animated: true) {
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtName.resignFirstResponder()
        txtSurname.resignFirstResponder()
        txtLogin.resignFirstResponder()
        txtPass.resignFirstResponder()
        txtPass2.resignFirstResponder()
        
        return true
    }
    
    @IBAction func btnRegPressed(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: self.txtLogin.text!, password: self.txtPass.text!) { (user, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Ядрена кочерыжка!", message: error!.localizedDescription,                                        preferredStyle: .alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Угу, ок", style: .cancel) { action -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
                
            else { print ("@@@@ok register: \(user) created.@@@")
                
                fireUser = user!
                // Сохранение данных пользователя
                //fireUser.******************************************************************
                self.ref.child("users").childByAutoId().setValue([ "login": self.txtLogin.text!,
                                                    "name": self.txtName.text!,
                                                   "surname": self.txtSurname.text!,
                                                   "date": String(describing: Date()),
                                                    "pass": self.txtPass.text!])

                // Сохранение изображения профайла пользователя в Хранилище
                let imageData = UIImagePNGRepresentation(self.imgUser.image!)
                let storageRef = self.storage.reference()

                // Create a reference to the file you want to upload
                let imgageRef = storageRef.child("profileImages/\(user!.email!)/profileImage.png")
                
                // Upload the file to the path
                let uploadTask = imgageRef.put(imageData!, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print("@@@ prifileImage: Uh-oh, an error occurred!")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata.downloadURL
                    print (downloadURL)
                }
                
//                let installation : PFInstallation = PFInstallation.current()!
//                installation["user"] = PFUser.current()
//                installation.saveInBackground()
                
                self.performSegue(withIdentifier: "toMainSegue", sender: self)
            }
            
            
            
        }

        
    }
 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let mainViewHeight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { 
            if UIScreen.main.bounds.height > 450 {
                self.view.center = CGPoint( x: mainViewWidth / 2, y: mainViewHeight / 2 - 110)
                self.imageView.addBlurEffect()
            }
        }, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let mainViewHeight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            if UIScreen.main.bounds.height > 450 {
                self.view.center = CGPoint( x: mainViewWidth / 2, y: mainViewHeight / 2 )
            }
        }, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        
    }
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }


}
