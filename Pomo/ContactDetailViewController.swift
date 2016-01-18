//
//  ContactDetailViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI

class ContactDetailViewController: UIViewController {
    
    var currentObject : PFObject?
    
    var noteObjects: NSMutableArray = NSMutableArray()
    
    //    @IBOutlet weak var userNameLabel: UILabel!
    //    @IBOutlet weak var propertyTitle: UILabel!
    //    @IBOutlet weak var propertyAddress: UILabel!
    //    @IBOutlet weak var propertyCity: UILabel!
    //    @IBOutlet weak var propertyState: UILabel!
    //    @IBOutlet weak var propertyZip: UILabel!
    //    @IBOutlet weak var propertyImage: PFImageView!
    //    @IBOutlet weak var userProfileImage: PFImageView!
    
    @IBOutlet weak var contactImage: PFImageView!
    
    @IBOutlet weak var contactUsername: UILabel!
    
    @IBOutlet weak var contactRole: UILabel!
    
    @IBOutlet weak var contactLocation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendMessageButton(sender: AnyObject) {
        let message = self.messageTextField.text
        if message!.characters.count < 1 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a message before sending", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
            presentViewController(alert, animated: true, completion: nil);
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newMessage = PFObject(className: "Message")
            
            newMessage["message"] = message
            newMessage["sender"] = PFUser.currentUser()
            newMessage["receiver"] = self.currentObject
            
            newMessage.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    //@IBOutlet weak var messageCount: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        //        if let pUserImage = PFUser.currentUser()?["image"] as? PFFile {
        //            self.userProfileImage.file = pUserImage
        //            self.userProfileImage.loadInBackground()
        //        }
        
        if let contact = currentObject as? PFUser {
            self.contactUsername.text = contact.username
            if let userRole = contact["userRole"] as? String {
                self.contactRole.text = userRole
                if (userRole == "tenant") {
                    if let location = contact["property"] as? PFObject {
                        self.contactLocation.text = location["address"] as? String
                    }
                }
            }
            
            if let contactImageFile = contact["image"] as? PFFile {
                self.contactImage.file = contactImageFile
                self.contactImage.loadInBackground()
            }
        }
        
        self.fetchAllMessagesFromLocalDatastore()
        
        self.fetchAllMessages()
        
        
        
        
        
        //self.tableView.reloadData()
    }
    
    func queryForMessages() {
        var messagesQuery: PFQuery!
        if currentObject != nil {
            let senderQuery = PFQuery(className: "Message")
            senderQuery.whereKey("sender", equalTo: currentObject!)
            senderQuery.whereKey("receiver", equalTo: PFUser.currentUser()!)
            let receiverQuery = PFQuery(className: "Message")
            receiverQuery.whereKey("receiver", equalTo: currentObject!)
            receiverQuery.whereKey("sender", equalTo: PFUser.currentUser()!)
            messagesQuery = PFQuery.orQueryWithSubqueries([senderQuery, receiverQuery])
        } else {
            print("no current object")
        }
        messagesQuery.orderByAscending("createdAt")
        //return messageQuery
        
    }
    
    func fetchAllMessagesFromLocalDatastore() {
        
        //var messageQuery = MessageInfo.query()
        var messageQuery: PFQuery!
        if currentObject != nil {
            let senderQuery = PFQuery(className: "Message")
            senderQuery.whereKey("sender", equalTo: currentObject!)
            senderQuery.whereKey("receiver", equalTo: PFUser.currentUser()!)
            let receiverQuery = PFQuery(className: "Message")
            receiverQuery.whereKey("receiver", equalTo: currentObject!)
            receiverQuery.whereKey("sender", equalTo: PFUser.currentUser()!)
            messageQuery = PFQuery.orQueryWithSubqueries([senderQuery, receiverQuery])
        } else {
            print("no current object")
        }
        messageQuery.orderByDescending("createdAt")
        
        messageQuery?.fromLocalDatastore()
        
        messageQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if (error == nil) {
                
                let temp: NSArray = objects as NSArray!
                self.noteObjects = temp.mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
                
            } else {
                
                print(error)
            }
        })
    }
    
    func fetchAllMessages() {
        
        PFObject.unpinAllInBackground(nil)
        
        //let messageInfo = MessageInfo.query()
        var messageInfo: PFQuery!
        if currentObject != nil {
            let senderQuery = PFQuery(className: "Message")
            senderQuery.whereKey("sender", equalTo: currentObject!)
            senderQuery.whereKey("receiver", equalTo: PFUser.currentUser()!)
            let receiverQuery = PFQuery(className: "Message")
            receiverQuery.whereKey("receiver", equalTo: currentObject!)
            receiverQuery.whereKey("sender", equalTo: PFUser.currentUser()!)
            messageInfo = PFQuery.orQueryWithSubqueries([senderQuery, receiverQuery])
        } else {
            print("no current object")
        }
        messageInfo?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if (error == nil) {
                
                PFObject.pinAllInBackground(objects, block: nil)
                
                self.fetchAllMessagesFromLocalDatastore()
                
                let numOfMessages : Int = self.noteObjects.count
                
                //self.messageCount.text = String(numOfMessages)
                
            } else {
                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let object = currentObject {
        //            println(object)
        //        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        let object : PFObject = self.noteObjects.objectAtIndex(indexPath.row) as! PFObject
        cell.messageText?.text = object["message"] as? String
        
        if let sender = object["sender"] as? PFUser {
            cell.senderName.text = sender.username
            if let senderImage = sender["image"] as? PFFile {
                cell.senderImage.file = senderImage
                cell.senderImage.loadInBackground()
            }
        }
        
        return cell
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
