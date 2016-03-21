//
//  Attitude.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 22/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreMotion

public class Attitude
{
    private var attitude:CMAttitude
    private var time:NSDate
    
    init(attitude:CMAttitude,time:NSDate)
    {
        self.attitude = attitude
        self.time = time
    }
    
    public func getAttiude() -> CMAttitude
    {
        return attitude
    }
    
    public func getTime() -> NSDate
    {
        return time
    }
}