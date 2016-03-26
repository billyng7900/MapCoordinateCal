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
    public func findTiltAngle(var gravityAngle:Double,var gravityAngle2:Double) -> Double
    {
        gravityAngle = abs(gravityAngle)
        gravityAngle2 = abs(gravityAngle2)
        return atan2(gravityAngle2, gravityAngle)
    }
}