//
//  GravityZ.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 23/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityZ: NSObject, Gravity
{
    public var isPositive:Bool
    
    init(isPositive:Bool)
    {
        self.isPositive = isPositive
    }

    public func getDegree(lowestPeakLocation:[Int],accelerationListY:[Acceleration],accelerationListX:[Acceleration]) -> Double
    {
        var xVector = Double()
        var yVector = Double()
        if !isPositive
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                yVector += accelerationListY[lowestPeakLocation[i]].getAcceleration()
            }
        }
        else
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                yVector += -(accelerationListY[lowestPeakLocation[i]].getAcceleration())
            }
        }
        xVector = xVector/Double(lowestPeakLocation.count)
        yVector = yVector/Double(lowestPeakLocation.count)
        var degree = CommonFunction.degreesFromRadians(atan2(xVector, yVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
}