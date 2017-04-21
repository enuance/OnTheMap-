//
//  StudentCell.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/19/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var OpaqueBG: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var media: UILabel!
    
    override func awakeFromNib() {super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        OpaqueBG.alpha = 0
        blurEffect.effect = nil
    }
    
    func animateSelection(completionHandler: @escaping () -> Void){
        UIView.animate(withDuration: 0.2, animations: ({
            self.blurEffect.effect = UIBlurEffect(style: .dark)
            self.OpaqueBG.alpha = 0.7
        })){successful in
            UIView.animate(withDuration: 0.1, animations: ({
                self.blurEffect.effect = nil
                self.OpaqueBG.alpha = 0
            })){successful in
                return completionHandler()
            }
        }
    }
    
}
