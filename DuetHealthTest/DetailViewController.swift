//
//  DetailViewController.swift
//  DuetHealthTest
//
//  Created by Tirumalasetty, Akhil on 8/14/16.
//  Copyright © 2016 Verizon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    @IBOutlet weak var thumbLabel: UILabel!
    
    
    @IBOutlet weak var textView: UITextView!
    
    var dataObject:AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 109.0/255.0, green: 132.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationItem.backBarButtonItem?.title="Back"
        // Do any additional setup after loading the view.
        
        print("SHOW DETAIL :: \(dataObject)")
        updateView( )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        

    }

    func updateView()
    {
        
        if let detail = self.dataObject {
            
            let description:NSString = detail["description"] as! NSString as String
            let gameName = detail["name"] as! NSString as String
            
            if let label = self.thumbLabel {
                label.text = gameName
            }
            
            if let textView = self.textView {
                textView.text = description as String
            }
            
            if let thumbView = self.thumbImageView {
                let urlPath = detail["image"] as! NSString as String
                let url = NSURL(string: urlPath)!
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url) { data, response, error in
                    
                    let thumbImage = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        thumbView.image = thumbImage
                    }
                }
                task.resume()
            }
            
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
