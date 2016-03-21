//
//  Acceleration.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 21/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class Acceleration
{
    private var acceleration:Double
    private var time:NSDate
    
    public init(acceleration:Double, time:NSDate)
    {
        self.acceleration = acceleration
        self.time = time
    }
    
    public func getAcceleration() -> Double
    {
        return acceleration
    }
    
    public func getTime() -> NSDate
    {
        return time
    }
}