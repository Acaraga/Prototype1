//
//  FeedTableViewController.swift
//  RSSReader
//
//  Created by Alex iMac on 17.04.17.
//  Copyright © 2017 Alex iMac. All rights reserved.
//

import UIKit
//import FrostedSidebar
import AFNetworking

var feedItems = [MWFeedItem]()


class FeedTableViewController: UITableViewController, MWFeedParserDelegate {

//    var sidebar: FrostedSidebar!
//    var selectedIndex = -1
    @IBOutlet weak var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        sidebar = FrostedSidebar(itemImages: [
//            UIImage(named: "add")!,
//            UIImage(named: "globe")!,
//            UIImage(named: "globe")!,
//            UIImage(named: "globe")!,
//            UIImage(named: "star")!,
//            UIImage(named: "star")!,
//            UIImage(named: "gear")!],
//                                 colors: [
//                                    UIColor(red: 240/255, green: 159/255, blue: 254/255, alpha: 1),
//                                    UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1),
//                                    UIColor(red: 126/255, green: 242/255, blue: 195/255, alpha: 1),
//                                    UIColor(red: 126/255, green: 242/255, blue: 195/255, alpha: 1),
//                                    UIColor(red: 126/255, green: 242/255, blue: 195/255, alpha: 1),
//                                    UIColor(red: 126/255, green: 242/255, blue: 195/255, alpha: 1),
//                                    UIColor(red: 119/255, green: 152/255, blue: 255/255, alpha: 1)],
//                                 selectionStyle: .single)
//        sidebar.actionForIndex = [
//            0: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0}) },
//            1: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1}) },
//            2: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 2}) },
//            3: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 3}) },
//            4: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 4}) },
//            5: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 5}) },
//            6: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 6}) },
//            7: {self.sidebar.dismissAnimated(true, completion: { finished in
//                                self.selectedIndex = 7}) }]
//        
//        sidebar.delegate = self

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        request()
        
    }
    
    
    // MARK: - feedParser methods
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        //моиself.title = info.title
        //self.navBar.title = info.title
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
    
    
    
    func request() {
        let url = URL(string: "http://www.texanerin.com/feed/")
        let feedParser = MWFeedParser(feedURL: url)
        feedParser?.delegate = self
        feedParser?.parse()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        let item = feedItems[indexPath.row] as MWFeedItem?
        cell.itemTitleLbl.text = item?.title
        cell.itemAuthorLbl.text = "" // \(String(describing: item?.author))"
        // Configure the cell...
        cell.itemImageView.image = UIImage(named: "globe")
        
        if item?.content != nil {
            
            let htmlContent = item!.content as NSString
            var imageSrc = ""
            
            if htmlContent.length > 0 {
            let rangeOfString = NSMakeRange(0, htmlContent.length)
            do {
                
                let regex = try NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)")
                let match = regex.firstMatch(in: htmlContent as String, options: [], range: rangeOfString)
                if (match != nil) {
                    let imageURL = htmlContent.substring(with: match!.rangeAt(2)) as NSString
                    print("**** \(imageURL)")
                    if NSString(string: imageURL.lowercased).range(of: "feedburner").location == NSNotFound {
                        imageSrc = imageURL as String
                    }
                    if imageSrc != "" {
                        
                        cell.itemImageView.setImageWith( NSURL(string: imageSrc)! as URL , placeholderImage: UIImage(named: "globe"))
                        
                    }
                    
                    
                }
                
            } catch {
                print (error.localizedDescription)
            }
            
            
                    
                
                
                
            
            
           
                
            }
            
        }
        
        
        
        
        
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feedItems[indexPath.row] as MWFeedItem
        let webBrowser = KINWebBrowserViewController()
        let url = URL(string: item.link)
        webBrowser.load(url)
        self.navigationController?.pushViewController(webBrowser, animated: true)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - SideBar
//    func sidebar(_ sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
//        if index == 0 {// =========  Add FEED ============
//            let alert = UIAlertController(title: "Add new feed", message: "Add feed name & URL", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: { (tf) in
//                tf.placeholder = "Feed name"
//            })
//            alert.addTextField(configurationHandler: { (tf) in
//                tf.placeholder = "Feed URL"
//            })
//            alert.addAction(UIAlertAction(title: "Cance", style: .cancel, handler: nil ))
//                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction: UIAlertAction) in
//                let textFields = alert.textFields
//                    let feedNameTF = textFields?.first!
//                    let feedURLTF = textFields?.last!
//                    if feedNameTF?.text != "" && feedURLTF?.text != "" {
//                        
//                        let feed =  Feed()
//                        feed.name = (feedNameTF?.text)!
//                        feed.url = (feedURLTF?.text)!
//                        let cda = CoreDataAgent()
//                        cda.saveDataForEntity(name: "Feed", data: feed)
//
//                        
//                    }
//                    
//                }))
//                    self.present(alert, animated: true, completion: nil)
//        }//========= end Add FEED ==============
//        else {
//            print (index)
//            if index == 1 {
//                
//                let cda = CoreDataAgent()
//                
//                let feeds: [Feed] = cda.loadDataForEntity(name: "Feed")! as! [Feed]
//            
//                for feed in feeds {
//                 
//                    print (feed)
//                }
//            
//        }
//    }
//    }
//    func sidebar(_ sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool){
//        
//    }
//    func sidebar(_ sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool){
//        
//    }
//    func sidebar(_ sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool){
//        
//    }
//    func sidebar(_ sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool){
//        
//    }
//    func sidebar(_ sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int){
//        
//    }
//    
//    @IBAction func btnOrg(_ sender: Any) {
//        
//        self.sidebar.showInViewController(self, animated: true)
//        
//        
//    }

}
