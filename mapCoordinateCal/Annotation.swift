//
//  Annotation.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 27/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


enum AnnotationType: Int
{
    case AnnotationDefault = 0
    case AnnotationUserLastLocation
    case AnnotationCalUserLocation
}

public class Annotation:NSObject,MKAnnotation
{
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    var type: AnnotationType
    
    init(coordinate:CLLocationCoordinate2D, title: String, subtitle:String, type: AnnotationType)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }

}