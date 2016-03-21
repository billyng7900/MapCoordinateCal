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
    var steps:Int
    var distance:Double
    var startDate:NSDate
    var endDate:NSDate
    var pace:NSNumber?
    var cadence:NSNumber?
    var altitudeChange:Double
    var bearing:Double
    
    init(steps:Int, distance:Double, startDate:NSDate, endDate:NSDate, pace:NSNumber?, cadence:NSNumber?, altitudeChange:Double, bearing:Double)
    {
        self.steps = steps
        self.distance = distance
        self.startDate = startDate
        self.endDate = endDate
        self.pace = pace
        self.cadence = cadence
        self.altitudeChange = altitudeChange
        self.bearing = bearing
    }
}
