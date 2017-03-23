//
//  SecondViewController.swift
//  Prototype1
//
//  Created by Acaraga on 10.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var lblQRBig: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addBlurEffect()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let qrc = Int(arc4random_uniform(1000000))
        let image = generateQRCode(from: "\(qrc)")
        self.qrImageView.image = image
        self.lblQRBig.text = "\(qrc)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

