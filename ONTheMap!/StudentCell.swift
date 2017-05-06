//
//  StudentCell.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/19/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This file allows us to implement a custom Cell that implements visual effects in the App's table view.
 */

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var media: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var OpaqueBG: UIView!
    
    override func awakeFromNib() {super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        OpaqueBG.alpha = 0
        blurEffect.effect = nil
    }
}


