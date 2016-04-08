//
//  CorrectionHeading.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 30/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class CorrectionHeading
{
    private var heading:Double
    private var startTime:NSDate
    
    init(heading:Double, startTime:NSDate)
    {
        self.heading = heading
        self.startTime = startTime
    }
    
    public func getHeading() -> Double
    {
        return heading
    }
    
    public func getStartTime() -> NSDate
    {
        return startTime
    }
}