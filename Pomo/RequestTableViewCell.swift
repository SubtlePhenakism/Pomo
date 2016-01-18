//
//  RequestTableViewCell.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class RequestTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var requestTitle: UILabel!
    @IBOutlet weak var requestStatus: UILabel!
    @IBOutlet weak var requestImage: PFImageView!
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    
}
