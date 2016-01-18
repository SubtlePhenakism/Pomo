//
//  RequestTableViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class RequestTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var usernameLabel: UIBarButtonItem!
    //var pfUserImage : PFImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureTableView()
        
        if let currentUser = PFUser.currentUser() {
            self.usernameLabel.title = currentUser.username
            //            if let userImageFile = currentUser["image"] as? PFFile {
            //                userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError?) -> Void in
            //                    if (error == nil) {
            //                        let image = UIImage(data:imageData)
            //                        self.usernameLabel.image = image
            //                    } else {
            //                        println("error")
            //                    }
            //                })
            //self.userImage.file = userImageFile
            //self.userImage.loadInBackground()
            //}
            // self.usernameLabel.image = self.userImage
            
        }
    }
    
    //    func configureTableView() {
    //        tableView.rowHeight = UITableViewAutomaticDimension
    //        tableView.estimatedRowHeight = 75.0
    //    }
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Request"
        self.textKey = "subject"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Request")
        query.includeKey("location")
        query.includeKey("sender")
        query.orderByDescending("createdAt")
        query.whereKey("receiver", equalTo: PFUser.currentUser()!)
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestTableViewCell!
        if cell == nil {
            cell = RequestTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RequestCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let propertyTitle = object?["location"] as? PFObject {
            cell.propertyTitle?.text = propertyTitle["address"] as? String
        }
        if let requestSender = object?["sender"] as? PFUser {
            cell.senderName.text = requestSender.username
        }
        if let requestTitle = object?["subject"] as? String {
            cell.requestTitle?.text = requestTitle
        }
        if let requestStatus = object?["status"] as? String {
            cell.requestStatus?.text = requestStatus
        }
        
        // Display flag image
        let initialThumbnail = UIImage(named: "question")
        cell?.requestImage?.image = initialThumbnail
        if let thumbnail = object?["image"] as? PFFile {
            cell.requestImage?.file = thumbnail
            cell.requestImage?.loadInBackground()
        }
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier! == "RequestViewToDetailView") {
            let detailScene = segue.destinationViewController as! RequestDetailViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = objects?[row]
            }
        } else if (segue.identifier == "menuSegue") {
            let menuScene = segue.destinationViewController as! MenuViewController
        }
    }
    
    
}
