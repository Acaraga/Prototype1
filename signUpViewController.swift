//
//  signUpViewController.swift
//  Prototype1
//
//  Created by Acaraga on 14.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class signUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
//    let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect.init())
//    let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: vibrancyEffect)
//   
    
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
            if subview.tag == 2 { subview.removeFromSuperview()}
        }
    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: self.txtLogin.text!, password: self.txtPassword.text!) { (user, error) in
            let uid = FIRAuth.auth()?.currentUser?.uid
            print("\(uid) loggin.")
            print("Error: \(error).")
            if error == nil {
                fireUser = user
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Ядрена кочерыжка!", message: error!.localizedDescription,                                        preferredStyle: .alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Угу, ок", style: .cancel) { action -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)

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
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    //}


}
