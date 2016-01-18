//
//  PropertyTableViewCell.swift
//  Pomo
//
//  Created by Robert Passemar on 1/16/16.
//  Copyright © 2016 TreeNine. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import Bolts

class PropertyTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var propertyAddress: UILabel!
    @IBOutlet weak var propertyImage: PFImageView!
    
}
