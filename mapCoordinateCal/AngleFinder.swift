//
//  AngleFiner.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 25/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class AngleFinder
{
    public func findTiltAngle(var gravityAngle:Double) -> Double
    {
        gravityAngle = abs(gravityAngle)
        return acos(gravityAngle/9.80665)
    }
    
    public func findDifferenceBetweenAngles(angle1:Double,angle2:Double) -> Double
    {
        var difference = angle2 - angle1
        if difference < -180
        {
            difference += 360
        }
        if difference > 180
        {
           difference -= 360
        }
        return difference
    }
}