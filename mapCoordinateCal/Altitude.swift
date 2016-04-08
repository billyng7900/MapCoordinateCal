//
//  Altitude.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 12/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class Altitude
{
    private var altitude:Double
    private var time:NSDate
    
    init(altitude:Double, time:NSDate)
    {
        self.altitude = altitude
        self.time = time
    }
    
    public func getAltitude() -> Double
    {
        return altitude
    }
    
    public func getTime() -> NSDate
    {
        return time
    }
}
