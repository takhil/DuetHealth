//
//  GamesListTableViewController.swift
//  DuetHealthTest
//
//  Created by Tirumalasetty, Akhil on 8/12/16.
//  Copyright © 2016 Verizon. All rights reserved.
//

import UIKit

class GamesListTableViewController: UITableViewController {
    
    //var detailViewController: DetailViewController? = nil
    
    var listOfGames = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 109.0/255.0, green: 132.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "Duet Health Test"
        
        loadGamesData()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfGames.count
    }
    
    // Navigation for detail view controller
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
        detailViewController!.dataObject = listOfGames[indexPath.row]
        self.navigationController?.pushViewController(detailViewController!, animated: true)
     

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        //accessing object through response
        let object:NSDictionary = listOfGames[indexPath.row] as! NSDictionary
        let description:NSString = object["description"] as! NSString as String
        let gameName = object["name"] as! NSString as String
        
        
            cell.textLabel!.text=gameName
            cell.detailTextLabel!.text=description as String
            cell.imageView!.image=nil
        
        
        // Image fetch URL with  GCD
        let urlPath = object["image"] as! NSString as String
        let url = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithURL(url) { data, response, error in
            
            let thumbImage = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath)
                cellToUpdate!.imageView!.image = thumbImage
                cellToUpdate!.setNeedsLayout()

            }
            
        }
        
        task.resume()
     
        return cell
    }
 
    
    func loadGamesData()
    {
        let gamesURLPath = "http://testing.eproximiti.com/api/games"
        getData(gamesURLPath)
    }
    
    func getData(requestURL:String) {
        let data = NSData(contentsOfURL: NSURL(string: requestURL)!)!
        parseJSON(data)
    }
    
    
    func parseJSON(data:NSData) {
        do {
            let jsonResult = try  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
           // print("NSDictionary Result :: \(jsonResult)")
            
            if let result = jsonResult["games"] as? NSArray {
                
               // print("Result games Array:: \(result)")
                
                listOfGames = result as [AnyObject]
            }
        }
        catch let error as NSError {
            print("Error details:: \(error.localizedDescription)")
        }

}
}

