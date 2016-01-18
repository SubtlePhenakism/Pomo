//
//  TableViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI

class TableViewController: PFQueryTableViewController {
    
    var nameVar = ""
    
    
    @IBOutlet weak var userNameLabel: UIBarButtonItem!
    
    @IBAction func add(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("TableViewToDetailView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.title = pUserName
        }
        
        //let propertyQuery = PFQuery(className:"Property")
        //if let user = PFUser.currentUser() {
        //    propertyQuery.whereKey("createdBy", equalTo: user)
        //}
    }
    
    override func viewWillAppear(animated: Bool) {
        //if (PFUser.currentUser() == nil) {
        let currentUser = PFUser.currentUser()?.username
        if currentUser == nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
    
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Property"
        self.textKey = "title"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Property")
        //query.orderByAscending("title")
        query.includeKey("currentContract")
        query.includeKey("username")
        query.includeKey("currentTenant")
        query.whereKey("owner", equalTo: (PFUser.currentUser()!))
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PropertyCell") as! PropertyTableViewCell!
        if cell == nil {
            cell = PropertyTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PropertyCell")
        }
        
        
        // Extract values from the PFObject to display in the table cell
        if let title = object?["title"] as? String {
            cell.propertyTitle?.text = title
        }
        if let address = object?["address"] as? String {
            cell.propertyAddress?.text = address
        }
        
        cell.propertyImage.image = UIImage(named: "home60")
        if let image = object?["image"] as? PFFile {
            cell.propertyImage?.file = image
            cell.propertyImage?.loadInBackground()
        }
        var name = ""
        if let contract = object?["currentContract"] as? PFObject {
            print(contract["lessee"])
            print(object?["currentTenant"])
            if let lessee = contract["lessee"] as? PFUser {
                print(lessee.objectId)
                let usernameQuery = try! PFQuery.getUserObjectWithId(lessee.objectId!)
                let tenantUsername = usernameQuery.username
                print(tenantUsername)
                name = (tenantUsername as String?)!
                
            }
            print("")
        }
        print(name)
        nameVar = (name as String?)!
        
        //        if let contract = object?["currentContract"] as? PFObject {
        //            var lessee = contract["lessee"] as! PFUser
        //            println(lessee)
        //                //var username = String?
        //                let usernameQ = PFUser.query()
        //                usernameQ?.whereKey("objectId", equalTo: lessee.objectId!)
        //                usernameQ?.includeKey("username")
        //            usernameQ?.findObjectsInBackgroundWithBlock({ ([NSObject :AnyObject]?, error:NSError) -> Void in
        //                    if let username = items["username"] as? String {
        //                    println(username)
        //                }
        //                })
        //            }
        
        // Display flag image
        //var initialThumbnail = UIImage(named: "question")
        //cell?.propertyImage?.image = initialThumbnail
        //if let thumbnail = object?["image"] as? PFFile {
        //    cell.propertyImage?.file = thumbnail
        //    cell.propertyImage?.loadInBackground()
        //}
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier! == "TableViewToDetailView") {
            let detailScene = segue.destinationViewController as! DetailViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = objects?[row]
                //detailScene.tName = nameVar
            }
        } else if (segue.identifier == "menuSegue") {
            let menuScene = segue.destinationViewController as! MenuViewController
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let objectToDelete = objects?[indexPath.row]
            objectToDelete!.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // Force a reload of the table - fetching fresh data from Parse platform
                    self.loadObjects()
                } else {
                    // There was a problem, check error.description
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
