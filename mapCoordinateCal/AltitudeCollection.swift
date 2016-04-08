//
//  AltitudeList.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 12/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class AltitudeCollection
{
    private var altitudeList = [Altitude]()
    private static var altitudeCollection = AltitudeCollection()
    
    
    public func isAltitudeListEmpty() -> Bool
    {
        return altitudeList.isEmpty
    }
    private init()
    {
        
    }
    
    public static func getAltitudeCollection() -> AltitudeCollection
    {
        return altitudeCollection
    }
    
    public func getAccumulatedAltitudeChange(timeStart:NSDate, timeEnd:NSDate) -> Double
    {
        var accumulatedAltitude = 0.0
        for altitude in altitudeList
        {
            if timeStart.compare(altitude.getTime()) != NSComparisonResult.OrderedDescending && timeEnd.compare(altitude.getTime()) != NSComparisonResult.OrderedAscending
            {
                accumulatedAltitude += altitude.getAltitude()
            }
        }
        return accumulatedAltitude
    }
    
    public func appendAltitude(altitude:Double,time:NSDate)
    {
        let altitudeObj = Altitude(altitude: altitude, time: time)
        altitudeList.append(altitudeObj)
    }
}