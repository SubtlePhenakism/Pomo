//
//  ContactTableViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class ContactTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var usernameLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = PFUser.currentUser() {
            self.usernameLabel.title = currentUser.username
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func queryForTable() -> PFQuery{
        let query = PFUser.query()
        //query.orderByAscending("username")
        query!.whereKey("userRole", equalTo:"tenant")
        //query?.includeKey("House")
        //var tenants = query!.findObjects()
        return query!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object:PFObject?) -> ContactTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactTableViewCell!
        if cell == nil {
            cell = ContactTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContactCell")
        }
        
        if let username = object?["username"] as? String {
            cell.contactName.text = username
        }
        
        if let image = object?["image"] as? PFFile {
            cell.contactImage?.file = image
            cell.contactImage?.loadInBackground()
        } else {
            cell.contactImage.image = UIImage(named: "dodo")
        }
        
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier! == "ContactTableViewToContactDetailView") {
            let detailScene = segue.destinationViewController as! ContactDetailViewController
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
