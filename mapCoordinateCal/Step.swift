//
//  Step.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 7/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class Step
{
    private var distance:Double
    private var endDate:NSDate
    private var altitudeChange:Double
    private var bearing:Double
    
    init(distance:Double, endDate:NSDate, altitudeChange:Double, bearing:Double)
    {
        self.distance = distance
        self.endDate = endDate
        self.altitudeChange = altitudeChange
        self.bearing = bearing
    }
    
    public func getDistance() -> Double
    {
        return distance
    }
    
    public func getEndDate() -> NSDate
    {
        return endDate
    }
    
    public func getAltitudeChange() -> Double
    {
        return altitudeChange
    }
    
    public func getBearing() -> Double
    {
        return bearing
    }
}
