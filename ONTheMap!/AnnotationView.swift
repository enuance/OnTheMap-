//
//  AnnotationView.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/16/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
import MapKit

//This Annotation Subclass gives our custom Annotation CallOuts the 
//ability to have hit detection using a UIControl Object such as a button.
class AnnotationView: MKAnnotationView {

    //Source code in this subclass is Courtessy of Malek from:
    //http://sweettutos.com/2016/03/16/how-to-completely-customise-your-map-annotations-callout-views/
    //Retrieved on 4/16/2016.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil){self.superview?.bringSubview(toFront: self)}
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside){
            for view in self.subviews{
                isInside = view.frame.contains(point)
                if isInside{break}
            }
        }
        return isInside
    }

}
