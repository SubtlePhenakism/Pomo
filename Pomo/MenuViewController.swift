//
//  MenuViewController.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
    func menuViewControllerDidTouchLogout(controller: MenuViewController)
    func menuViewControllerDidSelectCloseMenu(controller:MenuViewController)
    
}

class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var dialogView: DesignableView!
    weak var delegate: MenuViewControllerDelegate?
    //@IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if LocalStore.getToken() == nil {
        //loginLabel.text = "Login"
        //} else {
        //loginLabel.text = "Logout"
        //}
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
//        dismissViewControllerAnimated(true, completion: nil)
//        dialogView.animation = "fall"
//        dialogView.animate()
        delegate?.menuViewControllerDidSelectCloseMenu(self)
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    @IBAction func topButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func recentButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            LocalStore.deleteToken()
            self.closeButtonDidTouch(self)
            delegate?.menuViewControllerDidTouchLogout(self)
        }
    }
    
}
