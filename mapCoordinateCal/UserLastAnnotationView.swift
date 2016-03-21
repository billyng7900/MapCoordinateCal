//
//  UserLastAnnotationView.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 5/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import UIKit
import MapKit

class UserLastAnnotationView: MKAnnotationView
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = UIImage(named: "sf-ios-canvas-knob-blue@2x.png")
    }
}
