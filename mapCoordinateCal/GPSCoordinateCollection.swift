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
    private var gpsCoordinateList = [GPSCoordinate]()
    private static var gpsCoordinateCollection = GPSCoordinateCollection()
    
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
            if timeLimit.compare(coordinate.getTime()) != NSComparisonResult.OrderedDescending && locationAccuracyAllowRange >= coordinate.getAccuracy() && timeUpLimit.compare(coordinate.getTime()) != NSComparisonResult.OrderedAscending
            {
                if greatCoordinate != nil
                {
                    if coordinate.getAccuracy() < greatCoordinate?.getAccuracy()
                    {
                        greatCoordinate = coordinate
                    }
                    else if coordinate.getAccuracy() == greatCoordinate?.getAccuracy() && coordinate.getTime().compare((greatCoordinate?.getTime())!) != NSComparisonResult.OrderedDescending
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