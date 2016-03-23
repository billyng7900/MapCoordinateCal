//
//  GravityY.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 23/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityY: NSObject, Gravity
{
    public var isPositive:Bool
    
    init(isPositive:Bool)
    {
        self.isPositive = isPositive
    }

    public func getDegree(lowestPeakLocation:[Int],accelerationListY:[Acceleration],accelerationListX:[Acceleration]) -> Double
    {
        var xVector = Double()
        var zVector = Double()
        if isPositive
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                zVector += accelerationListY[lowestPeakLocation[i]].getAcceleration()
            }
        }
        else
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                zVector += -(accelerationListY[lowestPeakLocation[i]].getAcceleration())
            }
        }
        xVector = xVector/Double(lowestPeakLocation.count)
        zVector = zVector/Double(lowestPeakLocation.count)
        var degree = CommonFunction.degreesFromRadians(atan2(xVector, zVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
}