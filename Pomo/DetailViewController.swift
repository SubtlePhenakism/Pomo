//
//  DetailViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI

class DetailViewController: UIViewController {
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    @IBOutlet weak var imageToUpload: UIImageView!
    //var imageToUpload: UIImageView!
    
    @IBOutlet weak var propertyImageView: PFImageView!
    @IBOutlet weak var propertyTitleField: UITextField!
    @IBOutlet weak var propertyAddressField: UITextField!
    @IBOutlet weak var propertyCityField: UITextField!
    @IBOutlet weak var propertyStateField: UITextField!
    @IBOutlet weak var propertyZipcodeField: UITextField!
    
    @IBOutlet weak var tenantImageView: PFImageView!
    @IBOutlet weak var tenantName: UILabel!
    @IBOutlet weak var tenantCodeField: UITextField!
    
    @IBAction func changeImageButton(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func updateTenantCodeButton(sender: AnyObject) {
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        //            var alertController = UIAlertController(
        //                title:"Confirm Changes", message:"Are you sure you want to change this property info?", preferredStyle: UIAlertControllerStyle.Alert
        //            )
        //            var saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
        
        let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
        //
        //        //Upload a new picture
        //        //1
        //        let file = PFFile(name: "image", data: pictureData)
        //        file.saveInBackground()
        
        if let updateObject = self.currentObject as PFObject? {
            if (self.propertyTitleField.text != "") {
                updateObject["title"] = self.propertyTitleField.text
            }
            if (self.propertyAddressField.text != "") {
                updateObject["address"] = self.propertyAddressField.text
            }
            if (self.propertyCityField.text != "") {
                updateObject["city"] = self.propertyCityField.text
            }
            if (self.propertyStateField.text != "") {
                updateObject["state"] = self.propertyStateField.text
            }
            if (self.propertyZipcodeField.text != "") {
                updateObject["zip"] = self.propertyZipcodeField.text
            }
            if (self.imageToUpload != nil) {
                updateObject["image"] = PFFile(name: "image", data: pictureData!)
                print("image has value")
            }
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            updateObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                if ((error) != nil) {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    //                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    //                    alert.show()
                } else {
                    let alert = UIAlertController(title: "Success", message: "Your changes have been saved", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func updateTenantCodeAction(sender: AnyObject) {
        if let updateCode = currentObject as PFObject? {
            updateCode["tenantCode"] = tenantCodeField.text
            updateCode.saveInBackground()
        }
    }
    
    var currentTenant : PFUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.propertyTitleField.placeholder = "+ Title" as String
        self.propertyAddressField.placeholder = "+ Address" as String
        self.propertyCityField.placeholder = "+ City" as String
        self.propertyStateField.placeholder = "CA" as String
        self.propertyZipcodeField.placeholder = "Zipcode" as String
        self.tenantCodeField.placeholder = "+ Code" as String
        
        // Unwrap the current object
        
        if let object = currentObject {
            
            if let title = object["title"] as? String {
                if (title != "") {
                    self.propertyTitleField.placeholder = title
                }
            }
            if let address = object["address"] as? String {
                if (address != "") {
                    self.propertyAddressField.placeholder = address
                }
            }
            if let city = object["city"] as? String {
                if (city != "") {
                    self.propertyCityField.placeholder = city
                }
            }
            if let state = object["state"] as? String {
                if (state != "") {
                    self.propertyStateField.placeholder = state
                }
            }
            if let zipcode = object["zip"] as? String {
                if (zipcode != "") {
                    self.propertyZipcodeField.placeholder = zipcode
                }
            }
            if let tenantCode = object["tenantCode"] as? String {
                if (tenantCode != "") {
                    self.tenantCodeField.placeholder = tenantCode
                }
            }
            
            self.currentTenant = object["currentTenant"] as? PFUser
            self.tenantName.text = currentTenant?.username
            //self.tenantCodeField.placeholder = object["tenantCode"] as? String
            
            
            let initialPropertyThumbnail = UIImage(named: "home60")
            self.propertyImageView.image = initialPropertyThumbnail
            if let propertyThumbnail = object["image"] as? PFFile {
                self.propertyImageView.file = propertyThumbnail
                self.propertyImageView.loadInBackground()
            }
            
            let initialTenantThumbnail = UIImage(named: "question")
            self.tenantImageView.image = initialTenantThumbnail
            var currentTenantImage : PFFile
            if let info = currentTenant {
                if let currentTenantImage = info["image"] as? PFFile {
                    self.tenantImageView.file = currentTenantImage
                    self.tenantImageView.loadInBackground()
                }
            }
            //        if let tenantImage = currentTenant["image"] as? PFFIle {
            //            self.tenantUserImage.file = tenantImage
            //            self.tenantUserImage.loadInBackground()
            //        }
        }
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        //self.propertyImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
