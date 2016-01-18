//
//  SettingsViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI

protocol PhotoPickersDelegate
{
    func selectPhoto(var image : UIImage)
}

class SettingsViewController: UIViewController, PhotoPickersDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var unitCount: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func uploadUserImage(sender: AnyObject) {
        
    }
    
    func selectPhoto(image: UIImage)
    {
        userImage.image=image;
    }
    
    
    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    @IBOutlet weak var imageToUpload: UIImageView!
    //@IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var username: String?
    
    var profileImage : UIImage?
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    override func viewDidAppear(animated: Bool) {
        if let currentUserImage = PFUser.currentUser()?["image"] as? PFFile {
            self.profileImageView.file = currentUserImage
            self.profileImageView.loadInBackground()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (profileImage == nil){
            print("test1")
            //            var initialThumbnail = UIImage(named: "question")
            //            self.profileImageView.image = initialThumbnail
            print(profileImage)
        } else {
            print("TestImage")
            self.profileImageView.image = profileImage
            if let currentUserProfile = PFUser.currentUser() {
                print("user check")
                //currentUserProfile["image"] = profileImage
                let pictureData = UIImagePNGRepresentation(profileImage!)
                
                //Upload a new picture
                //1
                let file = PFFile(name: "image", data: pictureData!)
                file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if succeeded {
                        //2
                        self.saveUserImage(file!)
                        print("succeeded")
                    } else if let error = error {
                        //3
                        self.showErrorView(error)
                    }
                    }, progressBlock: { percent in
                        //4
                        print("Uploaded: \(percent)%")
                })
                
            }
        }
        
        var propertyArrary: [PFObject] = []
        var loggedInUserId : PFUser
        
        //var property : PFObject?
        if let loggedInUser = PFUser.currentUser() {
            self.usernameLabel.text = loggedInUser.username
            loggedInUserId = loggedInUser
            
            let propQuery = PFQuery(className: "Property")
            propQuery.whereKey("owner", equalTo: loggedInUserId)
            propQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil && objects != nil {
                    if let objects = objects as? [PFObject]! {
                        propertyArrary = objects
                        print("Successfully retrieved",(objects.count),"objects.")
                        self.unitCount.text = String(objects.count)
                    } }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    func saveUserImage(file: PFFile)
    {
        var userInfo : PFUser
        var userImage : PFFile
        
        if let userInfo = PFUser.currentUser() {
            let profileImageData = UIImagePNGRepresentation(profileImage!)
            let profileImageFile : PFFile = PFFile(data: profileImageData!)!
            userInfo["image"] = profileImageFile
            userInfo.saveInBackground()
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
