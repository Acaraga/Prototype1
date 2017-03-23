//
//  Scroll1ViewController.swift
//  Prototype1
//
//  Created by Acaraga on 17.03.17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class Scroll1ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var imageArray = [UIImage]()
 
    @IBOutlet weak var imageView: UIImageView!
    // создание параллельной  очереди
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)

    var timer: DispatchSourceTimer?
    var n = 0
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startTimer()
        imageView.addBlurEffect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation - collectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath)
        
        //let label1: UILabel = cell.viewWithTag(1) as! UILabel
        let imageView: UIImageView = cell.viewWithTag(2) as! UIImageView
        //let label2: UILabel = cell.viewWithTag(3) as! UILabel
        
        
        //label1.text = String(Int(ManagerData.sharedManager.weatherData[pageIndex].tempList[indexPath.row].temp))
        
        if imageArray.count == 3 {
            imageView.image = imageArray[indexPath.row]
            
        } else {
            
            imageView.image = (indexPath.row < 9) ? UIImage(named: "hd0\(indexPath.row+1)") : UIImage(named: "hd\(indexPath.row+1)")
            
        }
        //label2.text = ManagerData.sharedManager.weatherData[pageIndex].tempList[indexPath.row].dt
        
        return cell
    }
    //Use for size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        stopTimer()
        return true
    }
    
    //=============================================================
    func slideShow4 () {
        //=============================================================
        
        concurrentQueue.sync(){
            
            DispatchQueue.main.async {
              //  self.imageView4.image  = self.imageArray[self.n]
                self.collectionView.scrollToItem(at: IndexPath(item: self.n, section: 0), at: .centeredHorizontally, animated: true)
                
            }
            
            //print ("*** Showed pic No \(n)")
            n += 1
            if n > 12 { n = 0
                        self.stopTimer()}
        }
    }
    //=============================================================
    private func startTimer() {
        //=============================================================
        
        let queue = DispatchQueue(label: "com.firm.app.timer", attributes: .concurrent)
        
        timer?.cancel()        // cancel previous timer if any
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(2), leeway: .seconds(1))
        
        timer?.setEventHandler { [weak self] in // `[weak self]` only needed if you reference `self` in this closure and you want to prevent strong reference cycle
            self!.slideShow4()
        }
        
        timer?.resume()
    }
    //=============================================================
    private func stopTimer() {
        //=============================================================
        
        //        остановка таймера
        timer?.cancel()
        timer = nil
    }

    @IBAction func btnSitePressed(_ sender: Any) {
        
        let urltel = URL(string: "http://flyschool.ru")
        
        UIApplication.shared.openURL(urltel!)

    }
    @IBAction func btnTelPressed(_ sender: Any) {
    
        let urltel = URL(string: "tel://89263249998")
        
        UIApplication.shared.openURL(urltel!)
        
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
