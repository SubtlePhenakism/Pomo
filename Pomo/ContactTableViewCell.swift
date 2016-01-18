//
//  ContactTableViewCell.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import Bolts

class ContactTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactStatus: UILabel!
    @IBOutlet weak var contactImage: PFImageView!
    
}
