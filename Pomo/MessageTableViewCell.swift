//
//  MessageTableViewCell.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var senderImage: PFImageView!
    
}
