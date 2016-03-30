//
//  GravityZ.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 23/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityZY: NSObject, GravityCal
{
    public var angle:Double
    public var hAcceleration:Double
    public var vAcceleration:Double
    
    init(angle:Double,hAcceleration:Double,vAcceleration:Double)
    {
        self.angle = angle
        self.hAcceleration = hAcceleration
        self.vAcceleration = vAcceleration
    }
    
    public func getVerticalAcceleration() -> Double
    {
        return vAcceleration/cos(CommonFunction.radiansFromDegrees(angle))
    }
    
    public func getHorizontalAcceleartion() -> Double
    {
        return hAcceleration
    }
    
}