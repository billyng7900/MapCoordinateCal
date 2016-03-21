//
//  GPSCoordinate.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 12/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreLocation

public class GPSCoordinate
{
    var longitude:CLLocationDegrees
    var latitude:CLLocationDegrees
    var accuracy:Double
    var time:NSDate
    
    init(longitude:Double, latitude:Double, accuracy: Double, time:NSDate)
    {
        self.longitude = longitude
        self.latitude = latitude
        self.accuracy = accuracy
        self.time = time
    }
}
