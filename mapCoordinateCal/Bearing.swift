//
//  Bearing.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 10/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class Bearing
{
    private var bearing:Double
    private var time:NSDate
    
    init(bearing:Double, time:NSDate)
    {
        self.bearing = bearing
        self.time = time
    }
    
    public func getBearing() -> Double
    {
        return bearing
    }
    
    public func getTime() -> NSDate
    {
        return time
    }
}
