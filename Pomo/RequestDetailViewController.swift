//
//  RequestDetailViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class RequestDetailViewController: UIViewController {
    
    var currentObject : PFObject?
    
    @IBOutlet weak var requestImage: PFImageView!
    @IBOutlet weak var requestSubject: UILabel!
    @IBOutlet weak var requestDescription: UILabel!
    @IBOutlet weak var requestStatus: UILabel!
    
    @IBOutlet weak var senderImage: PFImageView!
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var unitTitle: UILabel!
    @IBOutlet weak var unitAddress: UILabel!
    @IBOutlet weak var propertyImage: PFImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let request = currentObject {
            //RequestInfo
            self.requestSubject.text = request["subject"] as? String
            self.requestDescription.text = request["note"] as? String
            self.requestStatus.text = request["status"] as? String
            //RequestImage
            let initialThumbnail = UIImage(named: "question")
            self.requestImage.image = initialThumbnail
            if let requestImageFile = request["image"] as? PFFile {
                self.requestImage.file = requestImageFile
                self.requestImage.loadInBackground()
            }
            
            //SenderInfo
            if let sender = request["sender"] as? PFUser {
                self.senderName.text = sender.username
                self.senderImage.image = initialThumbnail
                if let senderImageFile = sender["image"] as? PFFile {
                    self.senderImage.file = senderImageFile
                    self.senderImage.loadInBackground()
                }
                if let residence = sender["residence"] as? PFObject {
                    self.unitTitle.text = residence["title"] as? String
                    self.unitAddress.text = residence["address"] as? String
                    self.propertyImage.image = initialThumbnail
                    if let propertyImageFile = residence["image"] as? PFFile {
                        self.propertyImage.file = propertyImageFile
                        self.propertyImage.loadInBackground()
                    }
                }
            }
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
