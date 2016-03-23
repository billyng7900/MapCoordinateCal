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
        var weight:Double = 1
        var sum:Double = 0
        if isPositive
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration() * weight
                zVector += accelerationListY[lowestPeakLocation[i]].getAcceleration() * weight
                sum = sum + weight
                weight = weight + 0.2
            }
        }
        else
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                xVector += accelerationListX[lowestPeakLocation[i]].getAcceleration() * weight
                zVector += -(accelerationListY[lowestPeakLocation[i]].getAcceleration()) * weight
                sum = sum + weight
                weight = weight + 0.2
            }
        }
        xVector = xVector/Double(lowestPeakLocation.count)
        zVector = zVector/Double(lowestPeakLocation.count)
        var degree = CommonFunction.degreesFromRadians(atan2(xVector, zVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
}