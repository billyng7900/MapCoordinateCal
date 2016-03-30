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
        let customAnnotation = self.annotation as! Annotation
        var orginalImage = UIImage()
        switch(customAnnotation.type)
        {
        case .AnnotationDefault:
            orginalImage = UIImage(named: "pin")!
        case .AnnotationUserLastLocation:
            orginalImage = UIImage(named: "calBlueDot")!
        }
        let size = CGSize(width: 32, height: 32)
        UIGraphicsBeginImageContext(size)
        orginalImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = resizedImage
    }
}
