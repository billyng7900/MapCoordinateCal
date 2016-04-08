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
    private var longitude:CLLocationDegrees
    private var latitude:CLLocationDegrees
    private var accuracy:Double
    private var time:NSDate
    
    init(longitude:Double, latitude:Double, accuracy: Double, time:NSDate)
    {
        self.longitude = longitude
        self.latitude = latitude
        self.accuracy = accuracy
        self.time = time
    }
    
    public func getLongitude() -> CLLocationDegrees
    {
        return longitude
    }
    
    public func getLatitude() -> CLLocationDegrees
    {
        return latitude
    }
    
    public func getAccuracy() -> Double
    {
        return accuracy
    }
    
    public func getTime() -> NSDate
    {
        return time
    }
}
