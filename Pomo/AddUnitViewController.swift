//
//  AddUnitViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI

class AddUnitViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var imageToUpload: UIImageView!
    //@IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var code: String?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        
        //Disable the save button until we are ready
        navigationItem.rightBarButtonItem?.enabled = false
        
        loadingSpinner.startAnimating()
        
        //TODO: Upload a new picture
        //let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
        let pictureData = UIImageJPEGRepresentation(imageToUpload.image!, 0.5)
        
        //Upload a new picture
        //1
        let file = PFFile(name: "image", data: pictureData!)
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.savePropertyInfo(file!)
            } else if let error = error {
                //3
                self.showErrorView(error)
            }
            }, progressBlock: { percent in
                //4
                print("Uploaded: \(percent)%")
        })
    }
    
    func savePropertyInfo(file: PFFile)
    {
        //1
        let propertyInfo = PropertyInfo(image: file, user: PFUser.currentUser()!)
        //2
        propertyInfo.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                //4
                if let errorMessage = error?.userInfo["error"] as? String {
                    self.showErrorView(error!)
                }
            }
        }
    }
    
    
    
    @IBAction func addUnitAction(sender: AnyObject) {
        
        //let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
        let pictureData = UIImageJPEGRepresentation(imageToUpload.image!, 0.5)
        
        let property = PFObject(className:"Property")
        property["title"] = self.titleField.text
        property["address"] = self.addressField.text
        property["city"] = self.cityField.text
        property["state"] = self.stateField.text
        property["zip"] = self.zipField.text
        property["owner"] = PFUser.currentUser()
        property["image"] = PFFile(name: "image", data: pictureData!)
        let title = self.titleField.text
        code = title!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        property["tenantCode"] = code
        
        if self.cityField.text!.characters.count < 1 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter your city", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else if stateField.text!.characters.count < 2 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter your state", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else if zipField.text!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a vaild zip code", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            //var newProperty = PFObject()
            //newProperty["title"] = title
            
            
            
            property.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                
                spinner.stopAnimating()
                
                if ((error) != nil) {
//                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
//                    var alert = UIAlertView(title: "Success", message: "New property added!", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
                    let alert = UIAlertController(title: "Success", message: "New property added!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Nav")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.zipField.delegate = self
        self.stateField.delegate = self
        self.cityField.delegate = self
        self.addressField.delegate = self
        self.titleField.delegate = self
    }
    
    
}

extension AddUnitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
