//
//  GPSCoordinateCollection.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 12/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreLocation

public class GPSCoordinateCollection
{
    var gpsCoordinateList = [GPSCoordinate]()
    static var gpsCoordinateCollection = GPSCoordinateCollection()
    
    private init()
    {
        
    }
    
    public static func getGPSCoordinateCollection() -> GPSCoordinateCollection
    {
        return gpsCoordinateCollection
    }
    
    public func findOutMostRecentAccurateLocation(locationAccuracyAllowRange:Double, timeLimit:NSDate, timeUpLimit:NSDate) -> GPSCoordinate?
    {
        var greatCoordinate:GPSCoordinate?
        for coordinate in gpsCoordinateList
        {
            if timeLimit.compare(coordinate.time) != NSComparisonResult.OrderedDescending && locationAccuracyAllowRange >= coordinate.accuracy && timeUpLimit.compare(coordinate.time) != NSComparisonResult.OrderedAscending
            {
                if greatCoordinate != nil
                {
                    if coordinate.accuracy < greatCoordinate?.accuracy
                    {
                        greatCoordinate = coordinate
                    }
                    else if coordinate.accuracy == greatCoordinate?.accuracy && coordinate.time.compare((greatCoordinate?.time)!) != NSComparisonResult.OrderedDescending
                    {
                        greatCoordinate = coordinate
                    }
                }
                else
                {
                    greatCoordinate = coordinate
                }
            }
        }
        return greatCoordinate
    }
    
    public func appendGPSCoordinateList(longitude:CLLocationDegrees, latitude:CLLocationDegrees, accuracy:Double, time:NSDate)
    {
        let gpsCoordinate = GPSCoordinate(longitude: longitude, latitude: latitude, accuracy: accuracy, time: time)
        gpsCoordinateList.append(gpsCoordinate)
    }
}